From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] iw_cm: reject connect requests if cmid is not in LISTEN
Date: Thu, 23 Feb 2012 17:57:38 -0800
Message-ID: <CAL1RGDWkVJxEDZ5SaaSa8oA_y6a0u1NCbzTK9agsJE+V_YzimQ@mail.gmail.com>
References: <20120222214307.23921.83903.stgit@build.ogc.int>
 <CAL1RGDV7ZoKWgbh+ERF+af3_B7K2USAkXSPKWeQEg5atpHY0og@mail.gmail.com>
 <4F465A46.3060301@opengridcomputing.com> <4F4699A1.7030402@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F4699A1.7030402-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 23, 2012 at 11:55 AM, Steve Wise
<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> RIP: 0010:[<0000000000200200>] =A0[<0000000000200200>]

0x200200 is LIST_POISON2, which is set when something is removed
from a Linux list.

> =A0[<ffffffff8008c846>] __wake_up_common+0x3e/0x68
> =A0[<ffffffff8002e261>] __wake_up+0x38/0x4f
> =A0[<ffffffff8867410b>] :iw_cm:iw_cm_reject+0x5a/0xa7

So in the code

       if (cm_id_priv->state !=3D IW_CM_STATE_CONN_RECV) {
               spin_unlock_irqrestore(&cm_id_priv->lock, flags);
               clear_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags);
               wake_up_all(&cm_id_priv->connect_wait);
               return -EINVAL;
       }

the cm_id_priv->connect_wait is being corrupted before
or during the call to wake_up_all...

could the HW or low-level driver be generating events for
the incoming connections that are associated with the
listen ID, as the listen ID is being destroyed?

Maybe that's why the code silently ignored these requests
before :)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
