From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: IB/srp: merge fixes from MLNX_OFED
Date: Tue, 18 Feb 2014 18:42:51 +0100
Message-ID: <53039B9B.2080907@acm.org>
References: <53038E93.7050706@profitbricks.com> <530392D9.1010900@acm.org> <53039779.3080507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53039779.3080507-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/18/14 18:25, Sagi Grimberg wrote:
> Regarding the FMR unmap crash, I experienced it when running our
> distro-backported MLNX_OFED
> and hadn't got a chance to see if it reproduces in upstream yet. Thanks
> for confirming this reproduces here as well.
> Bart, Are you familiar with this issue? it should reproduce over mlx5
> driver or SRIOV (where FMRs are not supported).

The only issue I am aware of with regard to FMR and mlx4 was specific to
a single vendor kernel in which the FMR code had been modified. mlx4 +
FMR works fine AFAIK with RHEL, SLES and with upstream kernels.
Unfortunately I have not yet had the chance to give the mlx5 driver a try.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
