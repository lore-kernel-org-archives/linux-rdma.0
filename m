From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] Avoid running out of local port in RDMA_CM
Date: Wed, 23 Nov 2016 18:53:45 +0200
Message-ID: <CAG9sBKO7YVjKgGMOMBUxrtz3iU5GtkqPFu6j52g=RqR=d_0HHA@mail.gmail.com>
References: <CAG9sBKMMuj5Qf7_jgL_EAwOAVAFZCp5Wf=NytqsHAezrys97pA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0B611D@ORSMSX109.amr.corp.intel.com>
 <CAG9sBKMfGWv7-wgoSNxVqMs7TktcJ3a4J0QnL+TmPSm1kaQ28g@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A82373AB0B6164@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0B6164-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean

The documentation for struct inet_bind_bucket  says:
/* There are a few simple rules, which allow for local port reuse by
 * an application.  In essence:
 *
 *      1) Sockets bound to different interfaces may share a local port.
 *         Failing that, goto test 2.
 *      2) If all sockets have sk->sk_reuse set, and none of them are in
 *         TCP_LISTEN state, the port may be shared.
 *         Failing that, goto test 3.
 *      3) If all sockets are bound to a specific inet_sk(sk)->rcv_saddr local
 *         address, and none of them are the same, the port may be
 *         shared.
 *         Failing this, the port cannot be shared.
..

If I understand this correctly the suggestion in the RFC follows this
scheme so the request to mimic TCP/IP stack seems to be fulfilled.
If this breaks iWarp maybe we should forbid iWarp reusing the port
(with a flag on the rdma_id without being able to change it).

What do you say?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
