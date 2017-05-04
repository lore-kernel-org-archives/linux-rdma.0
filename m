From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [infiniband-core] question about arguments position
Date: Thu, 04 May 2017 19:49:06 -0400
Message-ID: <1493941746.3041.242.camel@redhat.com>
References: <20170504124209.Horde.B4I2tu9lZ9_KMd07dtjWcl2@gator4166.hostgator.com>
         <DB6PR0502MB2999ABEFF47AEBF944F8B65BD1EA0@DB6PR0502MB2999.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB6PR0502MB2999ABEFF47AEBF944F8B65BD1EA0-wTfl6qNNZ1N9V1xQXiTFbsDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-05-04 at 21:52 +0000, Parav Pandit wrote:
> Hi,
> 
> > 
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Gustavo A. R. Silva
> > Sent: Thursday, May 4, 2017 12:42 PM
> > To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Sean Hefty
> > <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>;
> > Sagi
> > Grimberg <sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org>; Bart Van Assche
> > <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; Steve Wise <swise@opengridcomputing.c
> > om>;
> > Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Yishai Hadas
> > <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: [infiniband-core] question about arguments position
> > 
> > 
> > Hello everybody,
> > 
> > While looking into Coverity ID 1351047 I ran into the following
> > piece of code at
> > drivers/infiniband/core/verbs.c:496:
> > 
> > ret = rdma_addr_find_l2_eth_by_grh(&dgid, &sgid,
> >                                     ah_attr->dmac,
> >                                     wc->wc_flags & IB_WC_WITH_VLAN
> > ?
> >                                     NULL : &vlan_id,
> >                                     &if_index, &hoplimit);
> > 
> > 
> > The issue here is that the position of arguments in the call to
> > rdma_addr_find_l2_eth_by_grh() function do not match the order of
> > the
> > parameters:
> > 
> > &dgid is passed to sgid
> > &sgid is passed to dgid
> > 
> > This is the function prototype:
> > 
> > int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
> > 				 const union ib_gid *dgid,
> > 				 u8 *dmac, u16 *vlan_id, int *if_index,
> > 				 int *hoplimit)
> > 
> > My question here is if this is intentional?
> > 
> Yes. ib_init_ah_from_wc() creates ah from the incoming packet.
> Incoming packet has dgid of the receiver node on which this code is
> getting executed
> And sgid contains the GID of the sender.
> 
> When resolving mac address of destination, you use arrived dgid as
> sgid.
> And use sgid as dgid because sgid contains destinations GID whom to
> respond to.

A patch to add a comment and forestall future questions here might be a
good addition.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
