From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 06/14] ib_srp: Micro-optimize completion handlers
Date: Mon, 12 Dec 2011 12:41:41 +0100
Message-ID: <CAO+b5-pFBEQybN+01heAzr=_dNCb7Sr7ri_o_hF1MnOeX4_idQ@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012002.17829.bvanassche@acm.org>
	<20111201163539.572ca669@thirdoffive.cmf.nrl.navy.mil>
	<1322782369.11664.5.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322782369.11664.5.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 2, 2011 at 12:32 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote=
:
> On Thu, 2011-12-01 at 16:35 -0500, chas williams - CONTRACTOR wrote:
>> perhaps this should use the unlikely() macro instead:
>>
>> =A0 =A0 =A0 if (unlikely(wc.status)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ...
>> =A0 =A0 =A0 }
>
> If it needs to change at all, this is the direction it should take.

Hi Dave,

Prepatch 3.2-rc5 has been released which means that the 3.3 merge
window is coming closer. Do you have any other comments about this
patch series than those already posted to the list ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
