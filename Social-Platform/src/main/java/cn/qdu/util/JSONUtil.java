package cn.qdu.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class JSONUtil {
    private static ObjectMapper objectMapper = new ObjectMapper();

    // 返回成功的JSON响应
    public static void success(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        ObjectNode result = objectMapper.createObjectNode();
        result.put("success", true);
        result.set("data", objectMapper.valueToTree(data));

        out.write(result.toString());
        out.flush();
        out.close();
    }

    // 返回失败的JSON响应
    public static void error(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        ObjectNode result = objectMapper.createObjectNode();
        result.put("success", false);
        result.put("error", message);

        out.write(result.toString());
        out.flush();
        out.close();
    }

    // 将对象转换为JSON字符串
    public static String toJSON(Object object) {
        try {
            return objectMapper.writeValueAsString(object);
        } catch (Exception e) {
            e.printStackTrace();
            return "{}";
        }
    }
}