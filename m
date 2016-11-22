From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] Avoid running out of local port in RDMA_CM
Date: Tue, 22 Nov 2016 19:52:52 +0200
Message-ID: <CAG9sBKMfGWv7-wgoSNxVqMs7TktcJ3a4J0QnL+TmPSm1kaQ28g@mail.gmail.com>
References: <CAG9sBKMMuj5Qf7_jgL_EAwOAVAFZCp5Wf=NytqsHAezrys97pA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0B611D@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0B611D-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 22, 2016 at 7:38 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> I believe that any solution here should mimic the TCP/IP stack as closely as possible.  So I would rule out the re-use of a single port for all active connections.
>
> I think TCP matches on the full tuple <src port, src ip, dst port, dst ip>.  We should be safe to re-use port numbers as long as some other portion of the tuple changes.  Maybe that can be added as part of the port reservation/checking?
>

At first the thought was to reuse ports as long as the dest IP between
rdma_id is different but is this complication really necessary?
RDMA_CM mimics socket API but wire protocol is different and source
port has no role in transporting a packet from QP to QP. Do you see a
real risk in reusing a port unconditionally?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
