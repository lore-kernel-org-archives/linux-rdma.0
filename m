From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: assertion failed in osm_switch_get_lft_block() function
Date: Sat, 20 Dec 2014 08:08:16 -0500
Message-ID: <549574C0.8030001@dev.mellanox.co.il>
References: <54948EB7.1020706@simula.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54948EB7.1020706-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/19/2014 3:46 PM, Vangelis Tasoulas wrote:
> Hello,
> 
> When I use LIDs from the top LFT block (0xbfc0-0xbfff), I get an
> assertion error from the function osm_switch_get_lft_block() which is
> implemented in osm_switch.c.
> 
> The line is this one:
> CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE <= IB_LID_UCAST_END_HO);
> 
> In the topmost LFT block, the base_lid_ho has the value 49088 and the
> IB_SMP_DATA_SIZE is 64. Together they add up to 49152 but the assertion
> checks if they are less than 0xbfff (49151).
> 
> Shouldn't this line be something like the following?
> 
> CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE - 1 <= IB_LID_UCAST_END_HO);
> 
> or
> 
> CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE <= IB_LID_UCAST_END_HO + 1);

Yes. Would you issue patch for this ?

Thanks.

-- Hal

> Cheers,
> Vangelis
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
