From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] Indirect Fast Memory registration support
Date: Mon, 13 Oct 2014 10:48:34 +0200
Message-ID: <543B91E2.70206@acm.org>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <543AD9CD.80803@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <543AD9CD.80803-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/12/14 21:43, Or Gerlitz wrote:
> Sean, Bart - any comment on the API before Sagi sits down to code the
> iSER changes?

Hello Or,

Will this API ever be supported by other Mellanox RDMA drivers than 
mlx5, e.g. mlx4 ? Will this API ever be supported by a Mellanox HCA that 
supports RoCE ? Additionally, do you perhaps know whether any other RDMA 
vendors have plans to implement this API for their RDMA HCA's ? Drivers 
like the iSER and SRP initiator and target drivers have been implemented 
on top of the RDMA API and support all hardware that implements the RDMA 
API. Since this patch series adds support for the indirect fast memory 
registration API for mlx5 only this means that adding support for this 
API in block storage drivers also means adding a fall-back path for RDMA 
drivers that do not have support for this API. That will make these 
block storage drivers harder to maintain, which is something I would 
like to avoid.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
