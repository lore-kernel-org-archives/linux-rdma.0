From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Sun, 19 Oct 2014 18:42:02 +0300
Message-ID: <5443DBCA.4000002@dev.mellanox.co.il>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com> <543CD5D6.1020506@mellanox.com> <44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <44d2d670-4785-4a76-8c05-f59791c999cf-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/15/2014 12:53 AM, Minh Duc Tran wrote:
> Hi Or Gerlitz,
> I am new to IB/iser so don't know much about the history of all these max settings being #define instead of taking the real numbers from querying the HW.  Yes, our HW driver is the ocrdma which distributes number of cqe per CQ up to 32 CQ.  There is a missing adjustable knob in iser to fine tune accordingly the underlining HW.  To give you some ideas how these values are being define now, here are the numbers and the added comments:
>

Hey Minh,

> ISER_MAX_RX_CQ_LEN             4096               /* This number should be calculated during create_session */

So in iSER CQs are shared a across the device - so this number
should satisfy maximum number of connections per CQ (which is currently 8).

> ISER_QP_MAX_RECV_DTOS    512                 /* Why can't we use ISCSI_DEF_XMIT_CMDS_MAX here ? */

iSER creates the connection QP when before the session is created - so
it doesn't know what the user will set at cmds_max (which is potentially
larger than ISCSI_DEF_XMIT_CMDS_MAX). So we allow 512 at the moment and
adjust the session cmds_max accordingly. I agree that this is a work
around for the moment as we don't know at QP creation time what is the
user setting of cmds_max.

> ISER_MAX_TX_CQ_LEN             36944           /* the mlx4 hw supports up to 3 CQ, but the ocrdma hw supports up to  32CQ with lower number of cqe per CQ */

What led you to conclude that: "the mlx4 hw supports up to 3 CQ"?
TX CQ length should be

> ISER_QP_MAX_REQ_DTOS       4618
> ISCSI_ISER_MAX_CONN            8                  /* I am not sure what this 8 connections per CQ is.  Open-iscsi will supports 1 connection per session so this can implies either one of these two things:
>                                                                                          1- mlx4 is limited to 8 sessions per CQ
>                                                                                          2- mlx4 is doing something proprietary on the hw to have multiple QP per session */

As I said, CQs are per device and shared across iscsi connections. So
each CQ will support up to 8 connections per CQ. I agree we should
allocate more CQs in case of more connections are opened - but we never
got any CQ to overrun (even in high stress) so this still on my todo
list...

> ISER_MAX_CQ                               4                  /* Should this number be much higher or bases on the number of cpu cores on the system to distribute CQ processing per core? */

I completely agree, This is a legacy MAX ceiling. I have a patch for
that pending at Or's table. I am all for getting it to 3.18/3.19

>
> We are open for suggestions.

OK,

I'll respond to Or's reply on the TODOs.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
