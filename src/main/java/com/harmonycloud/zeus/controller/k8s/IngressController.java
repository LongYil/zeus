package com.harmonycloud.zeus.controller.k8s;

import com.harmonycloud.caas.common.base.BaseResult;
import com.harmonycloud.caas.common.model.middleware.IngressDTO;
import com.harmonycloud.zeus.annotation.Authority;
import com.harmonycloud.zeus.service.k8s.IngressService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.harmonycloud.caas.common.constants.CommonConstant.ASTERISK;

/**
 * @author dengyulong
 * @date 2021/03/23
 */
@Api(tags = {"服务暴露","对外访问"}, value = "中间件对外访问")
@RestController
@RequestMapping("/clusters/{clusterId}/namespaces/{namespace}/middlewares")
public class IngressController {

    @Autowired
    private IngressService ingressService;

    @ApiOperation(value = "查询中间件对外访问列表", notes = "查询中间件对外访问列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "clusterId", value = "集群id", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "namespace", value = "命名空间", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "keyword", value = "模糊搜索", paramType = "query", dataTypeClass = String.class),
            @ApiImplicitParam(name = "type", value = "中间件类型", paramType = "query", dataTypeClass = String.class),
    })
    @GetMapping("/ingress")
    @Authority(power = 1)
    public BaseResult<List<IngressDTO>> list(@PathVariable("clusterId") String clusterId,
                                             @PathVariable(value = "namespace") String namespace,
                                             @RequestParam(value = "keyword", required = false) String keyword) {
        if (namespace.equals(ASTERISK)){
            namespace = null;
        }
        return BaseResult.ok(ingressService.listAllIngress(clusterId, namespace, keyword));
    }

    @ApiOperation(value = "创建中间件对外访问", notes = "创建中间件对外访问")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "clusterId", value = "集群id", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "namespace", value = "命名空间", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "middlewareName", value = "中间件名称", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "ingress", value = "对外访问信息", paramType = "query", dataTypeClass = IngressDTO.class)
    })
    @PostMapping("/{middlewareName}/ingress")
    @Authority(power = 1)
    public BaseResult create(@PathVariable("clusterId") String clusterId,
                             @PathVariable("namespace") String namespace,
                             @PathVariable("middlewareName") String middlewareName,
                             @RequestBody IngressDTO ingress) {
        ingressService.create(clusterId, namespace, middlewareName, ingress);
        return BaseResult.ok();
    }

    @ApiOperation(value = "删除中间件对外访问", notes = "删除中间件对外访问")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "clusterId", value = "集群id", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "namespace", value = "命名空间", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "middlewareName", value = "中间件名称", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "name", value = "对外访问名称", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "ingress", value = "对外访问信息", paramType = "query", dataTypeClass = IngressDTO.class)
    })
    @DeleteMapping("/{middlewareName}/ingress/{name}")
    @Authority(power = 1)
    public BaseResult delete(@PathVariable("clusterId") String clusterId,
                             @PathVariable(value = "namespace") String namespace,
                             @PathVariable("middlewareName") String middlewareName,
                             @PathVariable("name") String name,
                             @RequestBody IngressDTO ingress) {
        ingressService.delete(clusterId, namespace, middlewareName, name, ingress);
        return BaseResult.ok();
    }

    @ApiOperation(value = "获取中间件对外访问", notes = "获取中间件对外访问")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "clusterId", value = "集群id", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "namespace", value = "命名空间", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "middlewareName", value = "中间件名称", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "type", value = "中间件类型", paramType = "query", dataTypeClass = String.class)
    })
    @GetMapping("/{middlewareName}/ingress")
    @Authority(power = 1)
    public BaseResult<List<IngressDTO>> get(@PathVariable("clusterId") String clusterId,
                                      @PathVariable("namespace") String namespace,
                                      @PathVariable("middlewareName") String middlewareName,
                                      @RequestParam("type") String type) {
        return BaseResult.ok(ingressService.get(clusterId, namespace, type, middlewareName));
    }

    @ApiOperation(value = "校验服务端口是否可用", notes = "校验服务端口是否可用")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "clusterId", value = "集群id", paramType = "path", dataTypeClass = String.class),
            @ApiImplicitParam(name = "port", value = "中间件类型", paramType = "query", dataTypeClass = Integer.class)
    })
    @GetMapping("/verifyServicePort")
    public BaseResult verifyServicePort(@PathVariable("clusterId") String clusterId,
                                        @RequestParam("port") Integer port){
        ingressService.verifyServicePort(clusterId, port);
        return BaseResult.ok();
    }
    
}
