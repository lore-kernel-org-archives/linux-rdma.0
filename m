From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib mad definitions
Date: Tue, 19 Oct 2010 16:26:01 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1925B937603F@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
	<AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com>
	<AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com>
	<20101019102244.21cd2b1e.weiny2@llnl.gov>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB404C@orsmsx501.amr.corp.intel.com>
 <20101019134513.661470a8.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101019134513.661470a8.weiny2-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ira Weiny wrote:
> On Tue, 19 Oct 2010 11:50:46 -0700
> "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
>>> ib_types depends on complib at the moment (fixable)
>>> ibutils depends on OpenSM (it will anyway -- non-issue)
>>> somethings in ib_types are ugly, byteswapping (non-issue; deal with
>>> it later) OpenSM may _not_ include umad and therefore miss defines.
>>> (fixable?)
>>>
>>> As for this last item, would it be a big deal to require umad for
>>> the header only?  Does umad not compile somewhere that other vendor
>>> layers are used? I think it is much better for OpenSM to require
>>> umad than for other MAD processing software to require OpenSM.
>>> Also, would splitting ib_types help this at all?
>>
>> I'll propose the following:
>>
>> 1. Add to libibumad/include/infiniband:
>>
>>    umad_types.h - basic mad, rmpp headers
>>    umad_sa.h    - SA attributes
>>    umad_cm.h    - CM messages
>>
>> 2. Include umad_types.h and umad_sa.h from ib_types.h
>> 3. Include umad_cm.h from ib_cm_types.h
>>
>> We start with a minimal set of definitions to umad and add/move
>> other definitions later as needed, creating new header files where
>> appropriate (umad_smi.h, umad_pm.h, etc.)
>>
>> If we can get some basic agreement on this, I'll start on the
>> patches immediately.  In an ideal world, the new header files would
>> work on any platform.
>
> I agree,
> Ira

Just to be painfully clear ...
A user-mode application would then only need to include ib_types.h + CM flavor of choice .h files ?

>
>>
>> - Sean
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at
>> http://BLOCKEDvger.kernel.org/majordomo-info.html
>>
>
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
