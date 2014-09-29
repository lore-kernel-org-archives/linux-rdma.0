From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: Unable to compile RDMA-aware examples in C
Date: Mon, 29 Sep 2014 10:54:06 +0200
Message-ID: <1411980846.9750.0.camel@localhost.localdomain>
References: <loom.20140929T040000-389@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20140929T040000-389-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 29 septembre 2014 =C3=A0 02:08 +0000, floaterions a =C3=A9crit=
 :
> Hello everyone,
>=20
> I'm trying to run some basic rdma examples (provided here:
> github.com/tarickb/the-geek-in-the-corner/tree/master/01_basic-client=
-server
> but I keep getting these errors:
>=20
>=20
> $ gcc -Wall -g   -lrdmacm -libverbs -lpthread  server.c   -o server
> /tmp/cceNIRgz.o: In function `main':
> /rdma_cma/server.c:58: undefined reference to `rdma_create_event_chan=
nel'
> /rdma_cma/server.c:59: undefined reference to `rdma_create_id'
> /rdma_cma/server.c:60: undefined reference to `rdma_bind_addr'
> /rdma_cma/server.c:61: undefined reference to `rdma_listen'
> /rdma_cma/server.c:63: undefined reference to `rdma_get_src_port'
> /rdma_cma/server.c:71: undefined reference to `rdma_ack_cm_event'
> /rdma_cma/server.c:67: undefined reference to `rdma_get_cm_event'
> /rdma_cma/server.c:77: undefined reference to `rdma_destroy_id'
> /rdma_cma/server.c:78: undefined reference to `rdma_destroy_event_cha=
nnel'
> /tmp/cceNIRgz.o: In function `build_context':
> /rdma_cma/server.c:102: undefined reference to `ibv_alloc_pd'
> /rdma_cma/server.c:103: undefined reference to `ibv_create_comp_chann=
el'
> /rdma_cma/server.c:104: undefined reference to `ibv_create_cq'
> /rdma_cma/server.c:107: undefined reference to `pthread_create'
> /tmp/cceNIRgz.o: In function `poll_cq':
> /rdma_cma/server.c:130: undefined reference to `ibv_get_cq_event'
> /rdma_cma/server.c:131: undefined reference to `ibv_ack_cq_events'
> /tmp/cceNIRgz.o: In function `register_memory':
> /rdma_cma/server.c:163: undefined reference to `ibv_reg_mr'
> /rdma_cma/server.c:169: undefined reference to `ibv_reg_mr'
> /tmp/cceNIRgz.o: In function `on_connect_request':
> /rdma_cma/server.c:202: undefined reference to `rdma_create_qp'
> /rdma_cma/server.c:211: undefined reference to `rdma_accept'
> /tmp/cceNIRgz.o: In function `on_disconnect':
> /rdma_cma/server.c:248: undefined reference to `rdma_destroy_qp'
> /rdma_cma/server.c:250: undefined reference to `ibv_dereg_mr'
> /rdma_cma/server.c:251: undefined reference to `ibv_dereg_mr'
> /rdma_cma/server.c:258: undefined reference to `rdma_destroy_id'
> collect2: error: ld returned 1 exit status
>=20

Move the -l<lib> at the end of your command line:
$ gcc -Wall -g server.c   -o server -lrdmacm -libverbs -lpthread

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
