From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: SR-IOV support in MLX CX2
Date: Wed, 12 Jan 2011 16:15:42 +0200
Message-ID: <4D2DB78E.8020304@mellanox.co.il>
References: <1b60a08628454ebff84d72a1f748b9f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1b60a08628454ebff84d72a1f748b9f4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Lin Guay <weilin-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  On 1/10/2011 4:03 PM, Wei Lin Guay wrote:
> Hi all,
>
> Is Mellanox CX2 HCA supports SR-IOV? I'm currently using CentOS 5.5 with
> Xen 4.0.1 but open for any recommendation on different linux dist. The
> first blocking issue that I have is my CX2 doesn't have the SR-IOV
> extended capability in the PCI config dump as mentioned in the
> specification. What are the additional firmware/driver that is required in
> order to have the SR-IOV support in CX2? If SR-IOV is currently not
> supported, how can I enable PCI-bypass for CX2 in Xen?
>
>
>
CX2 is capable of supporting SRIOV, however we have not yet released FW 
and driver for this
This is under work now and I hope we will start submitting patches to 
the kernel soon ...

Tziporet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
