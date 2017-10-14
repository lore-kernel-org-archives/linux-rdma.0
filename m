From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 12/13] SoftiWarp debugging code
Date: Sat, 14 Oct 2017 01:08:23 +0000
Message-ID: <OF2AF63C69.E70035FE-ON002581B9.0006431B-002581B9.0006431D@notes.na.collabserv.com>
References: <20171008123950.GU25829@mtr-leonro.local>,<20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-13-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171008123950.GU25829-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

-----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----

>To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>Date: 10/08/2017 02:40PM
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 12/13] SoftiWarp debugging code
>
>On Fri, Oct 06, 2017 at 08:28:52AM -0400, Bernard Metzler wrote:
>> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/siw/siw_debug.c | 442
>++++++++++++++++++++++++++++++++++
>>  drivers/infiniband/sw/siw/siw_debug.h | 178 ++++++++++++++
>>  2 files changed, 620 insertions(+)
>>  create mode 100644 drivers/infiniband/sw/siw/siw_debug.c
>>  create mode 100644 drivers/infiniband/sw/siw/siw_debug.h
>>
>
>NACK to all this code.
>It is general to all iWARP devices and it is going to be part of
>RDMAtool, in this and/or next kernel cycle.
>
>Thanks
>

Okay.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
