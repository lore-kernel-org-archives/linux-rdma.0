From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH/RFC] RDMA/iwcm: Get rid of enum iw_cm_event_status
Date: Wed, 11 May 2011 19:40:08 +0200
Message-ID: <BANLkTik33-CDiBfcaCr+kv99GnACAtNpeQ@mail.gmail.com>
References: <1305005199-4943-1-git-send-email-roland@kernel.org> <4DCABFEA.10501@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DCABFEA.10501-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 11, 2011 at 6:57 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
>
> Roland Dreier wrote:
>>
>> This also gets rid of the warning
>> =A0 =A0drivers/infiniband/core/cma.c: In function 'cma_iw_handler':
>> =A0 =A0drivers/infiniband/core/cma.c:1333:3: warning: case value '42=
94967185' not in enumerated type 'enum iw_cm_event_status'
>> =A0 =A0drivers/infiniband/core/cma.c:1336:3: warning: case value '42=
94967186' not in enumerated type 'enum iw_cm_event_status'
>> =A0 =A0drivers/infiniband/core/cma.c:1332:3: warning: case value '42=
94967192' not in enumerated type 'enum iw_cm_event_status'
>
> Roland, so how did you manage to see that warning, is it your plane g=
cc (what version?)
> or through using some static checker? for example, I don't see it wit=
h the latest sparse.

I see these warnings every time I recompile the kernel with gcc 4.5.1.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
