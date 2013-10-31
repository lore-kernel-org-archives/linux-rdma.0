From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC v2 00/10] Introduce Signature feature
Date: Thu, 31 Oct 2013 13:55:57 +0100
Message-ID: <5272535D.4090805@gmail.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383222255-22699-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

I wander what's the performance overhead with this DIF support?
And is there a roadmap for support SRP/ISER and target side for DIF?

Regards,
Jack


On 10/31/2013 01:24 PM, Sagi Grimberg wrote:
> This patchset Introduces Verbs level support for signature handover
> feature. Siganture is intended to implement end-to-end data integrity
> on a transactional basis in a completely offloaded manner.
> 
> There are several end-to-end data integrity methods used today in various
> applications and/or upper layer protocols such as T10-DIF defined by SCSI
> specifications (SBC), CRC32, XOR8 and more. This patchset adds verbs
> support only for T10-DIF. The proposed framework allows adding more
> signature methods in the future.
> 
> In T10-DIF, when a series of 512-byte data blocks are transferred, each
> block is followed by an 8-byte guard. The guard consists of CRC that
> protects the integrity of the data in the block, and some other tags
> that protects against mis-directed IOs.
> 
> Data can be protected when transferred over the wire, but can also be
> protected in the memory of the sender/receiver. This allows true end-
> to-end protection against bits flipping either over the wire, through
> gateways, in memory, over PCI, etc.
> 
> While T10-DIF clearly defines that over the wire protection guards are
> interleaved into the data stream (each 512-Byte block followed by 8-byte
> guard), when in memory, the protection guards may reside in a buffer
> separated from the data. Depending on the application, it is usually
> easier to handle the data when it is contiguous. In this case the data
> buffer will be of size 512xN and the protection buffer will be of size
> 8xN (where N is the number of blocks in the transaction).
> 
> There are 3 kinds of signature handover operation:
> 1. Take unprotected data (from wire or memory) and ADD protection
>    guards.
> 2. Take protetected data (from wire or memory), validate the data
>    integrity against the protection guards and STRIP the protection
>    guards.
> 3. Take protected data (from wire or memory), validate the data
>    integrity against the protection guards and PASS the data with
>    the guards as-is.
> 
> This translates to defining to the HCA how/if data protection exists
> in memory domain, and how/if data protection exists is wire domain.
> 
> The way that data integrity is performed is by using a new kind of
> memory region: signature-enabled MR, and a new kind of work request:
> REG_SIG_MR. The REG_SIG_MR WR operates on the signature-enabled MR,
> and defines all the needed information for the signature handover
> (data buffer, protection buffer if needed and signature attributes).
> The result is an MR that can be used for data transfer as usual,
> that will also add/validate/strip/pass protection guards.
> 
> When the data transfer is successfully completed, it does not mean
> that there are no integrity errors. The user must afterwards check
> the signature status of the handover operation using a new light-weight
> verb.
> 
> This feature shall be used in storage upper layer protocols iSER/SRP
> implementing end-to-end data integrity T10-DIF. Following this patchset,
> we will soon submit krping patches which will demonstrate the usage of
> these signature verbs.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
