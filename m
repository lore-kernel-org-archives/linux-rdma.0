From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/nes: double CLOSE event indication crash
Date: Mon, 16 Aug 2010 07:32:07 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9049F5E881C@azsmsx506.amr.corp.intel.com>
References: <20100814210456.GA7116@FLATIF-MOBL3>
 <4C677DD9.5030308@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C677DD9.5030308-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>-----Original Message-----
>From: Or Gerlitz [mailto:ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org]
>Sent: Sunday, August 15, 2010 12:41 AM
>To: Latif, Faisal
>Cc: Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH] RDMA/nes: double CLOSE event indication crash
>
>Faisal Latif wrote:
>> During a stress testing in a large cluster, multiple close event is
>detected
>> and BUG() is hit in core. The cause is [...]
>
>Do you refer to the core of the IB stack? if not, to whose core?
>
>
>Or.

Hi Or

BUG() was in iw_cm.ko in its close handler mentioned as core in my email and caused by iw_nes.ko.

Faisal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
