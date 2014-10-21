From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Tue, 21 Oct 2014 17:49:24 +0300
Message-ID: <54467274.7040006@dev.mellanox.co.il>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com> <543CD5D6.1020506@mellanox.com> <44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com> <5443DBCA.4000002@dev.mellanox.co.il> <ecfd3441-253c-47bf-b2cb-030b2a00f689@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ecfd3441-253c-47bf-b2cb-030b2a00f689-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/20/2014 8:36 AM, Minh Duc Tran wrote:
> Hi Sagi,
>
> I've created a new patch over the 21 iser patches you have mentioned early in this thread.  It is pasted at the end of this email.
> If I understand correctly, this patch will be applied along with Or's TODO list.
>
>
>>> ISER_MAX_RX_CQ_LEN             4096               /* This number should be calculated during create_session */
>
>> So in iSER CQs are shared a across the device - so this number should satisfy maximum number of connections per CQ (which is currently 8).
>
> Again, there should be no rules enforcing a CQ to support 8 connections.  The underlining hw should be able to supports more or less as it is configured to do.  Specific to the ocrdma hw, it has lower number of CQE per CQ but it has 32 CQ

We can take the minimum of supported, calculated.

>
>>> ISER_QP_MAX_RECV_DTOS    512                 /* Why can't we use ISCSI_DEF_XMIT_CMDS_MAX here ? */
>
>> iSER creates the connection QP when before the session is created - so it doesn't know what the user will set at cmds_max (which is potentially larger than ISCSI_DEF_XMIT_CMDS_MAX). So we allow 512 at the moment and adjust the session cmds_max accordingly. I agree that this is a >work around for the moment as we don't know at QP creation time what is the user setting of cmds_max.
>
> Like any other drivers, we should limit this number to the range hw supports.  If user setting is within hw range then number will be adjusted accordingly.  If user setting is not within hw range, set it to default values.
> What about something like this:
> #define ISER_GET_MAX_XMIT_CMDS(send_wr) (send_wr - ISER_MAX_TX_MISC_PDUS - \
> 					ISER_MAX_RX_MISC_PDUS)	/	\
> 					 (1 + ISER_INFLIGHT_DATAOUTS)
> cmds_max_supported = ISER_GET_MAX_XMIT_CMDS(dev_attr->max_qp_wr)
>

I agree, but we should not let the user set too much commands if we do.

>
>>> ISER_MAX_TX_CQ_LEN             36944           /* the mlx4 hw supports up to 3 CQ, but the ocrdma hw supports up to  32CQ with lower number of cqe per CQ */
>
>> What led you to conclude that: "the mlx4 hw supports up to 3 CQ"?
>> TX CQ length should be
>
> I was debugging some iser target problems sometimes back.  I could be wrong with 3CQ but it's not far from the hard limit of 4CQ set by current ib/iser code

This specifically originates in a mlx4_core bug in RoCE mode (supports
only 3 EQs). CCing Matan who promised me he would fix it...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
