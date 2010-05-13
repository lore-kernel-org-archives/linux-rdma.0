From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv8 07/11] ib_core: Add API to support IBoE from userspace
Date: Thu, 13 May 2010 12:11:45 -0700
Message-ID: <A2C75A9348C942C3BAB7A2F0FF1B6CAB@amr.corp.intel.com>
References: <20100218172425.GH12286@mtls03>	<adak4r8uaog.fsf@roland-alpha.cisco.com>	<20100513135645.GL16073@mtldesk030.lab.mtl.com>	<8172EB57F9DF4F93BBFAD583235E8C3F@amr.corp.intel.com> <20100513165447.GB19438@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100513165447.GB19438-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Eli Cohen' <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>In this case it will not be just mapping remote addresses but creating
>the required AH information which is unique to each device.

I understand that the AH is per device.  What I don't get is why we would want
each device to perform the mapping.  We don't expect the device to map GIDs to
LIDs when creating an AH.  The user must have done the mapping beforehand.  The
mapping does not depend on which device I'm using, it should be the same.

Basically, what I want to understand is why does this change make sense?

@@ -1139,6 +1139,10 @@ struct ib_device {
 						  struct ib_grh *in_grh,
 						  struct ib_mad *in_mad,
 						  struct ib_mad *out_mad);
+	int			   (*get_eth_l2_addr)(struct ib_device *device,
u8 port,
+						      union ib_gid *dgid, int
sgid_idx,
+						      u8 *mac, u16 *vlan_id, u8
*tagged);
+

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
