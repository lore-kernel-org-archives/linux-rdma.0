From: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: [PATCHv8 07/11] ib_core: Add API to support IBoE from
	userspace
Date: Mon, 17 May 2010 19:31:21 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB4439A7327B0D@MTLMAIL.mtl.com>
References: <20100218172425.GH12286@mtls03>
	<adak4r8uaog.fsf@roland-alpha.cisco.com>
	<20100513135645.GL16073@mtldesk030.lab.mtl.com>
	<8172EB57F9DF4F93BBFAD583235E8C3F@amr.corp.intel.com>
	<20100513165447.GB19438@mtldesk030.lab.mtl.com>
	<A2C75A9348C942C3BAB7A2F0FF1B6CAB@amr.corp.intel.com>
	<ada4oibsj9c.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <ada4oibsj9c.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If we have a dedicated ABI call for this mapping, then it seems reasonable to have it device independent.
However, this mapping is really only used when creating address handles.

So, we can base the mapping on the (device specific) create_ah() flow, but provide generic mapping functions for all devices to use (this is kind of what happens now).
Also, using create_ah() doesn't introduce an ABI call that is specific to ib-->eth mappings.

This is similar to how device-specific ib_reg_user_mr() functions call the generic ib_umem_get()...

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
Sent: Thursday, May 13, 2010 10:18 PM
To: Sean Hefty
Cc: 'Eli Cohen'; Eli Cohen; Linux RDMA list; ewg
Subject: Re: [PATCHv8 07/11] ib_core: Add API to support IBoE from userspace

 > Basically, what I want to understand is why does this change make sense?
 >
 > @@ -1139,6 +1139,10 @@ struct ib_device {
 >  						  struct ib_grh *in_grh,
 >  						  struct ib_mad *in_mad,
 >  						  struct ib_mad *out_mad);
 > +	int			   (*get_eth_l2_addr)(struct ib_device *device,
 > u8 port,
 > +						      union ib_gid *dgid, int
 > sgid_idx,
 > +						      u8 *mac, u16 *vlan_id, u8
 > *tagged);
 > +

Yes, that was pretty much my original question.  Why do we have a verb for userspace to call a device-specific method to do the mapping?  The layering seems wrong somewhere if we have a generic verb to do this mapping, but then put the mapping in device-specific code.

 - R.
--
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
