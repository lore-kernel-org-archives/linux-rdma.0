From: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibumad: add string functions for various enums
Date: Fri, 1 Mar 2013 17:56:33 -0800
Message-ID: <CAMLCd9L2gkMEAxo2evE66R55RcGPct2WWre=wBav1zYTkA3Pdw@mail.gmail.com>
References: <20130301114034.85fdbe136d503d803cb167ae@llnl.gov>
 <51311E07.8070209@dev.mellanox.co.il> <20130301133305.29edc9171b3a264b277e34ed@llnl.gov>
 <1828884A29C6694DAF28B7E6B8A823736F3561BF@ORSMSX101.amr.corp.intel.com>
 <20130301140811.99423e66848a1509e08bc5ec@llnl.gov> <1828884A29C6694DAF28B7E6B8A823736F35620C@ORSMSX101.amr.corp.intel.com>
 <24c3c83e-bd79-4e10-8569-6106860d43a1@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <24c3c83e-bd79-4e10-8569-6106860d43a1-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Resend to the list.  My phone apparently sends html which was rejected.

On Fri, Mar 1, 2013 at 5:51 PM, Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Never mind. I was thinking the check for busy and redirect were "==" not a
> mask.
>
> Sorry many things going on today.
>
> So I think we are good then?
>
> Ira
>
>
>
> "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > If those reserve fields are either A) not correctly set to 0 or B) are
>> > used for
>>>
>>> some future status this function will fail.  Since the spec says to
>>> ignore them
>>> I would do something like.
>>>
>>>  status = ntohs(status);
>>>  status &= 0x001F;
>>>
>>> With a #define'd mask for 1F of course...  ;-)
>>
>>
>> Your proposed implementation already ignores those bits.  I'm confused.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> www.lightcipher.com



-- 
=====================
http://www.lightcipher.com/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
