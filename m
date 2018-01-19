From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 01/12] rdma/ib: Add trace point macros to display
 human-readable values
Date: Fri, 19 Jan 2018 11:19:20 -0500
Message-ID: <73857AF2-BE14-451B-AC9D-1F2B2395CCB7@oracle.com>
References: <20171220210236.29321.59307.stgit@manet.1015granger.net>
 <20171220213023.29321.97527.stgit@manet.1015granger.net>
 <1245d090-99ee-c517-5f8f-afdb7ffc0456@Netapp.com>
 <20180118223446.GB17294@ziepe.ca>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180118223446.GB17294-uk2M96/98Pc@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> On Jan 18, 2018, at 5:34 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>=20
> On Thu, Jan 18, 2018 at 04:49:20PM -0500, Anna Schumaker wrote:
>> Hi Folks,
>>=20
>> On 12/20/2017 04:30 PM, Chuck Lever wrote:
>>> These can be shared with all kernel ULPs, and more can easily be
>>> added as needed.
>>>=20
>>> Note: checkpatch.pl has some heartburn with the TRACE_DEFINE_ENUM
>>> macros and the LIST macros. These follow the same style as other
>>> header files under include/tracing/events , thus should be
>>> considered acceptable exceptions.
>>>=20
>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> include/trace/events/rdma.h |  128 =
+++++++++++++++++++++++++++++++++++++++++++
>>> 1 file changed, 128 insertions(+)
>>> create mode 100644 include/trace/events/rdma.h
>>=20
>> Just checking that it's okay to send this through the NFS tree,
>> since it goes along with the rest of Chuck's patches?
>=20
> New file, won't create any conflicts, so should be fine.
>=20
> Is this API or anything that needs a really special look?
>=20
>>> +++ b/include/trace/events/rdma.h
>>> @@ -0,0 +1,128 @@
>>> +/*
>>> + * Copyright (c) 2017 Oracle.  All rights reserved.
>>> + */
>=20
> This should have a SPDX header though, from what I understand.

If Anna adds SPDX headers to the files introduced in this series,
can we get an Acked-by for this patch from one of the RDMA
maintainers? Or is that not necessary?


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
