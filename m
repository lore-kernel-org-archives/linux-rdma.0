From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: rdma_getaddrinfo and GUID
Date: Sun, 19 Jul 2015 00:15:50 +0300
Message-ID: <CACaajQsauS65K8tKwygPB03iyv87uy8s-jPn7_gihqbEU6np3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello, does it possible to use rdma_getaddrinfo and specify in node port GUID?
I'm try with fe80:0000:0000:0000:0002:c903:00ef:6651 this simple test:
#include <stdlib.h>
#include <stdio.h>
#include <rdma/rdma_cma.h>
#include <infiniband/ib.h>

int main(int argc, char **argv) {
  struct rdma_addrinfo *hints, *info;
  int ret = -1;
  hints = malloc(sizeof(hints));
  memset(hints, '\0', sizeof(hints));
  hints->ai_flags = RAI_NUMERICHOST;
  hints->ai_family = AF_IB;
  //  hints->ai_port_space = RDMA_PS_IB;
  ret = rdma_getaddrinfo(argv[1], NULL, hints, &info);
  if (ret < 0) {
    fprintf(stderr, "%d rdma_getaddrinfo\n", ret);
    return ret;
  }
  if (info == NULL) {
    fprintf(stderr, "%d rdma_getaddrinfo null\n", ret);
    return -1;
  }
  return 0;
}

But getting INET6 address
Also noted that i don't enable IPoIB, why address not IF_IB family ?

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
