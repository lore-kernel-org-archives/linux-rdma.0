From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Wed, 3 May 2017 10:41:51 -0400
Message-ID: <CAHC9VhSB6AORJf_8cBGt-AynMsEh3snKU5SpsmNXoy9hDSrGaA@mail.gmail.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479910651-43246-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 23, 2016 at 9:17 AM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Infiniband applications access HW from user-space -- traffic is generated
> directly by HW, bypassing the kernel. Consequently, Infiniband Partitions,
> which are associated directly with HW transport endpoints, are a natural
> choice for enforcing granular mandatory access control for Infiniband. QPs may
> only send or receives packets tagged with the corresponding partition key
> (PKey). The PKey is not a cryptographic key; it's a 16 bit number identifying
> the partition.
>
> Every Infiniband fabric is controlled by a central Subnet Manager (SM). The SM
> provisions the partitions by assigning each port with the partitions it can
> access. In addition, the SM tags each port with a subnet prefix, which
> identifies the subnet. Determining which users are allowed to access which
> partition keys on a given subnet forms an effective policy for isolating users
> on the fabric. Any application that attempts to send traffic on a given subnet
> is automatically subject to the policy, regardless of which device and port it
> uses. SM software configures the subnet through a privileged Subnet Management
> Interface (SMI), which is presented by each Infiniband port. Thus, the SMI must
> also be controlled to prevent unauthorized changes to fabric configuration and
> partitioning.
>
> To support access control for IB partitions and subnet management, security
> contexts must be provided for two new types of objects - PKeys and IB ports.
>
> A PKey label consists of a subnet prefix and a range of PKey values and is
> similar to the labeling mechanism for netports. Each Infiniband port can reside
> on a different subnet. So labeling the PKey values for specific subnet prefixes
> provides the user maximum flexibility, as PKey values may be determined
> independently for different subnets. There is a single access vector for PKeys
> called "access".
>
> An Infiniband port is labeled by device name and port number. There is a single
> access vector for IB ports called "manage_subnet".
>
> Because RDMA allows kernel bypass, enforcement must be done during connection
> setup. Communication over RDMA requires a send and receive queue, collectively
> known as a Queue Pair (QP). A QP must be initialized by privileged system calls
> before it can be used to send or receive data. During initialization the user
> must provide the PKey and port the QP will use; at this time access control can
> be enforced.
>
> Because there is a possibility that the enforcement settings or security
> policy can change, a means of notifying the ib_core module of such changes
> is required. To facilitate this a generic notification callback mechanism
> is added to the LSM. One callback is registered for checking the QP PKey
> associations when the policy changes. Mad agents also register a callback,
> they cache the permission to send and receive SMPs to avoid another per
> packet call to the LSM.
>
> Because frequent accesses to the same PKey's SID is expected a cache is
> implemented which is very similar to the netport cache.
>
> In order to properly enforce security when changes to the PKey table or
> security policy or enforcement occur ib_core must track which QPs are
> using which port, pkey index, and alternate path for every IB device.
> This makes operations that used to be atomic transactional.
>
> When modifying a QP, ib_core must associate it with the PKey index, port,
> and alternate path specified. If the QP was already associated with
> different settings, the QP is added to the new list prior to the
> modification. If the modify succeeds then the old listing is removed. If
> the modify fails the new listing is removed and the old listing remains
> unchanged.
>
> When destroying a QP the ib_qp structure is freed by the decive specific
> driver (i.e. mlx4_ib) if the 'destroy' is successful. This requires storing
> security related information in a separate structure. When a 'destroy'
> request is in process the ib_qp structure is in an undefined state so if
> there are changes to the security policy or PKey table, the security checks
> cannot reset the QP if it doesn't have permission for the new setting. If
> the 'destroy' fails, security for that QP must be enforced again and its
> status in the list is restored. If the 'destroy' succeeds the security info
> can be cleaned up and freed.
>
> There are a number of locks required to protect the QP security structure
> and the QP to device/port/pkey index lists. If multiple locks are required,
> the safe locking order is: QP security structure mutex first, followed by
> any list locks needed, which are sorted first by port followed by pkey
> index.

Hi Dan,

I haven't heard anything from you in a while, where do things stand
with this effort?  Unless I missed them, I believe we are still
waiting on the userspace, SELinux reference policy, and
selinux-testsuite patches.

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
