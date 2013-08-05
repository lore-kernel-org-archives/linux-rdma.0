From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Mon, 5 Aug 2013 13:06:36 -0700
Message-ID: <CAL1RGDWPHWzAWx7XXxGGCVQQ1xHU6QDVybrttnvoqUPrzqzvWA@mail.gmail.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F6F31A6@xmb-rcd-x01.cisco.com>
 <CAL1RGDU+4CSJyF0TAfAv-YYcjA4FG+XNeg5pGCHPeW5iqhvwpA@mail.gmail.com>
 <20130708172621.GA3852@obsidianresearch.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F70BF83@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373805AAB74@ORSMSX109.amr.corp.intel.com>
 <20130716144747.GA7304@obsidianresearch.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F7211E6@xmb-rcd-x01.cisco.com>
 <CAL1RGDWKmecLXsqphwdP9XG=4Y=65Z_ACSdRBhEqVQb6Q4LrUg@mail.gmail.com>
 <51E6DB11.9050906@redhat.com> <CAL1RGDVuuQU-NZ2o+T0_kuxPMRadGPeqzO1J9iuW=DRuFMMYfQ@mail.gmail.com>
 <20130805190238.GA14356@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130805190238.GA14356-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 5, 2013 at 12:02 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> Wouldn't the following be a better path forward:
>>
>>  - Add a new API (ibv_get_max_datagram_size() or some such) that
>> returns the real value as an int, based on the true MTU
>>  - Have old query verbs continue to return only old MTU values, but
>> deprecate that field with the idea of removing it in a few years

> It isn't that easy, one API certainly doesn't cover it. The MTU is in
> two structs:

> struct ibv_port_attr
> struct ibv_qp_attr

> Which touch ibv_query_port, ibv_modify_qp and ibv_query_qp. All of
> which need to be changed, and you can't change the _qp functions just
> by adding a new call.

Well, for full generality I agree we would have to handle the QP
stuff.  But for now at least the only QPs that need (or allow) MTU to
be set are connected (RC, UC and XRC) QPs.  The current motivation for
allowing extended MTU is for datagrams.  So strictly speaking we only
need to deal with the query port verb.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
