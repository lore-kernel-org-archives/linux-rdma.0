From: <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 5/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Thu, 22 Mar 2012 01:12:49 -0700
Message-ID: <88B766C272F2C64B944B21AD078333151C964A6580@EXMAIL.ad.emulex.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-2-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-3-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-4-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-5-git-send-email-parav.pandit@emulex.com>
 <a20fecd6-5214-4787-a974-04d61732c679@exht1.ad.emulex.com>
 <1828884A29C6694DAF28B7E6B8A8237345197ADB@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237345197ADB-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Thursday, March 22, 2012 6:14 AM
> To: Pandit, Parav; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [PATCH 5/9] ocrdma: Driver for Emulex OneConnect RDMA
> adapter
> 
> > +static int ocrdma_inet6addr_event(struct notifier_block *,
> > +				  unsigned long, void *);
> > +
> > +static struct notifier_block ocrdma_inet6addr_notifier = {
> > +	.notifier_call = ocrdma_inet6addr_event };
> > +
> > +int ocrdma_get_instance(void)
> > +{
> > +	int instance = 0;
> > +
> > +	/* Assign an unused number */
> > +	if (!idr_pre_get(&ocrdma_dev_id, GFP_KERNEL))
> > +		return -1;
> > +	if (idr_get_new(&ocrdma_dev_id, NULL, &instance))
> > +		return -1;
> > +	return instance;
> > +}
> > +
> > +void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid) {
> > +	u8 mac_addr[6];
> > +
> > +	memcpy(&mac_addr[0], &dev->nic_info.mac_addr[0], ETH_ALEN);
> > +	guid[0] = mac_addr[0] ^ 2;
> > +	guid[1] = mac_addr[1];
> > +	guid[2] = mac_addr[2];
> > +	guid[3] = 0xff;
> > +	guid[4] = 0xfe;
> > +	guid[5] = mac_addr[3];
> > +	guid[6] = mac_addr[4];
> > +	guid[7] = mac_addr[5];
> > +}
> > +
> > +static void ocrdma_build_sgid_mac(union ib_gid *sgid, unsigned char
> > *mac_addr,
> > +				  bool is_vlan, u16 vlan_id)
> > +{
> > +	sgid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
> > +	sgid->raw[8] = mac_addr[0] ^ 2;
> > +	sgid->raw[9] = mac_addr[1];
> > +	sgid->raw[10] = mac_addr[2];
> > +	if (is_vlan) {
> > +		sgid->raw[11] = vlan_id >> 8;
> > +		sgid->raw[12] = vlan_id & 0xff;
> > +	} else {
> > +		sgid->raw[11] = 0xff;
> > +		sgid->raw[12] = 0xfe;
> > +	}
> > +	sgid->raw[13] = mac_addr[3];
> > +	sgid->raw[14] = mac_addr[4];
> > +	sgid->raw[15] = mac_addr[5];
> > +}
> > +
> > +static void ocrdma_add_sgid(struct ocrdma_dev *dev, unsigned char
> *mac_addr,
> > +			    bool is_vlan, u16 vlan_id)
> > +{
> > +	int i;
> > +	bool found = false;
> > +	union ib_gid new_sgid;
> > +	int free_idx = OCRDMA_MAX_SGID;
> > +	unsigned long flags;
> > +
> > +	memset(&ocrdma_zero_sgid, 0, sizeof(union ib_gid));
> 
> ocrdma_zero_sgid should already be zeroed
> 
Yes. Removed memset().

> Actually, can't we either use in6addr_any instead?  I see that the mlx4 driver
> also has a zero gid.  So, if we don't want to overload the use of in6addr_any,
> we can define gid_zero in ib_core.

o.k. once its defined in ib_core, will remove this and provide a subsequent patch. It will be easier to handle it.

> 
> > +
> > +	ocrdma_build_sgid_mac(&new_sgid, mac_addr, is_vlan, vlan_id);
> > +
> > +	spin_lock_irqsave(&dev->sgid_lock, flags);
> > +	for (i = 0; i < OCRDMA_MAX_SGID; i++) {
> > +		if (!memcmp(&dev->sgid_tbl[i], &ocrdma_zero_sgid,
> > +			    sizeof(union ib_gid))) {
> > +			/* found free entry */
> > +			if (!found) {
> > +				free_idx = i;
> > +				found = true;
> > +				break;
> > +			}
> > +		} else if (!memcmp(&dev->sgid_tbl[i], &new_sgid,
> > +				   sizeof(union ib_gid))) {
> > +			/* entry already present, no addition is required. */
> > +			spin_unlock_irqrestore(&dev->sgid_lock, flags);
> > +			return;
> > +		}
> > +	}
> > +	/* if entry doesn't exist and if table has some space, add entry */
> > +	if (found)
> > +		memcpy(&dev->sgid_tbl[free_idx], &new_sgid,
> > +		       sizeof(union ib_gid));
> 
> can move memcpy into for loop and remove found flag
> 
Yes, removed.

> > +	spin_unlock_irqrestore(&dev->sgid_lock, flags); }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
