From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 07/11] ib_core: Add API to support IBoE from
	userspace
Date: Thu, 13 May 2010 12:18:23 -0700
Message-ID: <ada4oibsj9c.fsf@roland-alpha.cisco.com>
References: <20100218172425.GH12286@mtls03>
	<adak4r8uaog.fsf@roland-alpha.cisco.com>
	<20100513135645.GL16073@mtldesk030.lab.mtl.com>
	<8172EB57F9DF4F93BBFAD583235E8C3F@amr.corp.intel.com>
	<20100513165447.GB19438@mtldesk030.lab.mtl.com>
	<A2C75A9348C942C3BAB7A2F0FF1B6CAB@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <A2C75A9348C942C3BAB7A2F0FF1B6CAB-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Thu, 13 May 2010 12:11:45 -0700")
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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

Yes, that was pretty much my original question.  Why do we have a verb
for userspace to call a device-specific method to do the mapping?  The
layering seems wrong somewhere if we have a generic verb to do this
mapping, but then put the mapping in device-specific code.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
