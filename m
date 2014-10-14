From: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and
 send_wr
Date: Tue, 14 Oct 2014 21:53:35 +0000
Message-ID: <44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
 <543CD5D6.1020506@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <543CD5D6.1020506-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or Gerlitz,
I am new to IB/iser so don't know much about the history of all these max settings being #define instead of taking the real numbers from querying the HW.  Yes, our HW driver is the ocrdma which distributes number of cqe per CQ up to 32 CQ.  There is a missing adjustable knob in iser to fine tune accordingly the underlining HW.  To give you some ideas how these values are being define now, here are the numbers and the added comments:

ISER_MAX_RX_CQ_LEN             4096               /* This number should be calculated during create_session */
ISER_QP_MAX_RECV_DTOS    512                 /* Why can't we use ISCSI_DEF_XMIT_CMDS_MAX here ? */ 
ISER_MAX_TX_CQ_LEN             36944           /* the mlx4 hw supports up to 3 CQ, but the ocrdma hw supports up to  32CQ with lower number of cqe per CQ */
ISER_QP_MAX_REQ_DTOS       4618
ISCSI_ISER_MAX_CONN            8                  /* I am not sure what this 8 connections per CQ is.  Open-iscsi will supports 1 connection per session so this can implies either one of these two things:
                                                                                        1- mlx4 is limited to 8 sessions per CQ
                                                                                        2- mlx4 is doing something proprietary on the hw to have multiple QP per session */
ISER_MAX_CQ                               4                  /* Should this number be much higher or bases on the number of cpu cores on the system to distribute CQ processing per core? */

We are open for suggestions.

-Minh

-----Original Message-----
From: Or Gerlitz [mailto:ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org] 
Sent: Tuesday, October 14, 2014 12:51 AM
To: Jay Kallickal; Minh Duc Tran
Cc: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jayamohan Kallickal
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr


On 10/8/2014 2:41 AM, Jay Kallickal wrote:
> This patch allows the underlying hardware to choose values other than  
> hard coded max values for cqe and send_wr while preventing them from 
> exceeding max supported values.

These values are not "just" hard coded. If your HW driver (ocrdma?) can't support them, the way to fix that is different e.g use smaller number of commands per session. I don't see the point to rebase the patch before make a small design discussion here.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
