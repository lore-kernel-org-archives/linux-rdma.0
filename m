From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 3/9] net/mlx4_core: Set initial admin GUIDs for
 VFs
Date: Tue, 31 Mar 2015 12:54:56 +0300
Message-ID: <551A6EF0.4090300@mellanox.com>
References: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com>
 <1427637093-6711-4-git-send-email-ogerlitz@mellanox.com>
 <20150330171631.GA1152@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150330171631.GA1152-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/30/2015 8:16 PM, Jason Gunthorpe wrote:
> But, it doesn't really make sense to use eth_random_addr (which
> doesn't have a special OUI) and not randomize every bit.
>
>          get_random_bytes(&guid, sizeof(guid));
>          guid &= ~(1ULL << 56);
> 	guid |= 1ULL << 57;

OK, we can do that, sure.

> I also don't think the kernel should be generating random GUIDs. Either the SA should be consulted to do this, or the management stack should generate a cloud wide unique number.

There **is** an option to consult with the SM controlled by the 
sm_guid_assign module param of mlx4_ib. When this mode is in action, the 
randomized guid would be overridden by the one assigned by the SA.

In real life environments, people will use the "host assigned" option 
(sm_guid_assign = false) where the virtualization systems generate a 
unique guid to be used by the VF/VM and provision it through mlx4_ib to 
be provided to VF when the bindin.

The only place where the random value will be used, is for OOTB 
experience for staging purposes and such, when one wants to have working 
system with zero-touch. The practice of generating locally random 
address for non-provisioned VF is also used by the pretty much the whole 
set of Ethernet VF drivers (ixgbe_vf, i40e_vf, mlx4 VF code, etc). This 
is low cost solution for point cases which need that.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
