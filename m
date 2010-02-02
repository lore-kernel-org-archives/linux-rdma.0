From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: IBoE patches vs the dual IB/iWARP stack
Date: Tue, 02 Feb 2010 07:04:11 +0200
Message-ID: <4B67B24B.50803@voltaire.com>
References: <382A478CAD40FA4FB46605CF81FE39F44FE7B5EE@orsmsx507.amr.corp.intel.com>	<603F8A3875DCE940BA37B49D0A6EA0AE58CFBB79@azsmsx501.amr.corp.intel.com>	<603F8A3875DCE940BA37B49D0A6EA0AE58CFBE7F@azsmsx501.amr.corp.intel.com>	<4B576195.6000402@mellanox.co.il>	<382A478CAD40FA4FB46605CF81FE39F44FE7C052@orsmsx507.amr.corp.intel.com> <44A0A9C45C604E4C8EF3ECF93A21F8BC@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <44A0A9C45C604E4C8EF3ECF93A21F8BC-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> It appears that the dev_type is ARPHDR_ETHER.  Is this correct, or should a
> different dev_type be used?  Maybe some sort of mapping from ARPHDR_* dev_type
> to an RDMA device type is needed in ib_addr, possibly in rdma_copy_addr().
> Looking at a struct net_device, how do we know what kind of RDMA device we have
> if the ARPHDR dev_type isn't sufficient?
>
> For the call to rdma_addr_get_sgid(), maybe the name or purpose of that call
> needs to be changed, with a second call being added.  What cma_acquire_dev()
> wants is a local device address so that it can match the net_device up with the
> ib_device.  Perhaps there's a cleaner way to do this than calling
> rdma_addr_get_sgid() from cma_acquire_dev().
>
> Along these same lines, why can't the 'sgid' be incorporated into the
> src_dev_addr, similar to what is done for iwarp devices?  I don't really
> understand the function rocee_mac_to_ll(), and maybe it's just the name.  I'm
> assuming that 'll' stands for link-layer, correct?  Since the MAC address is a
> link-layer address, what layer is the GID

I believe that all Sean's comments apply to the mainline submission of 
the IBoE patches, so lets see how they are addressed  throughout the 
review process.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
