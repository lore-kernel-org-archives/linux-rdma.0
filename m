From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 00/13] Request for Comments on SoftiWarp
Date: Wed, 25 Oct 2017 15:43:24 +0000
Message-ID: <OFD4910512.EE81083F-ON002581C4.005628D8-002581C4.00565F19@notes.na.collabserv.com>
References: <20171020162521.GA2106@mtr-leonro.local>,<20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171020134501.GD11604@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020162521.GA2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

-----linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote: -----

>To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>From: Leon Romanovsky 
>Sent by: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Date: 10/20/2017 06:25PM
>Cc: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 00/13] Request for Comments on SoftiWarp
>
>On Fri, Oct 20, 2017 at 08:45:01AM -0500, Shiraz Saleem wrote:
>> On Fri, Oct 06, 2017 at 08:28:40AM -0400, Bernard Metzler wrote:
>> >
>> > To experiment with the current siw code, we suggest cloning our
>out-of-tree
>> > development repo at https://github.com/zrlio/softiwarp.
>> > Here, the branch 'dev-siw.mem_ext' contains the most recent code
>> > development status, which is currently in sync with the patch.
>> > Testing siw requires the installation of both user library and
>kernel
>> > module, located within userlib/ and kernel/ respectively. That
>siw
>> > version expects a running kernel of version >= 4.12.
>> >
>>
>> So you need OFED (which ver. ?) installed for user-space?
>> Is there a plan to integrate your user-space into rdma core? Would
>be
>> easier to evaulate/test.
>
>I doubt that someone will seriously think to accept SIW into the
>kernel,
>before seeing complementary part for the rdma-core.
>
>Thanks

@Leon
Right. siw started when there was no rdma-core, but some OFED code
base. I learned I have to re-base it to comply with rdma-core.

@Shiraz
One can test the current code by cloning from 
https://github.com/zrlio/softiwarp as stated above. check out
the 'dev-siw.mem_ext' branch to make and run on 4.13. That version
expects RDMA support, installed for your preferred distro
(librdmacm and libibverbs installed, etc.). But let's not further
discuss running siw off-tree here; the github page has a contact
pointer if you want to give it a try and run into issues with it.

>
>>
>> Shiraz
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
[attachment "signature.asc" removed by Bernard Metzler/Zurich/IBM]

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
