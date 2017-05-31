From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: How do I generate and set a GUID on an Ethernet VF with ConnectX-4?
Date: Wed, 31 May 2017 09:40:42 -0600
Message-ID: <CAANLjFqTRd1sk75jhUXEV892wK2yLPytA0DDQzhWirzJAFCN6Q@mail.gmail.com>
References: <CAANLjFoHJhCJpZ+9uogHE4nSLkrdTRbGgS4mO5un_M+mNYdmCw@mail.gmail.com>
 <847B5D33-D362-40F1-82B6-DB2F7B2BA1AA@mellanox.com> <CAANLjFpMXrO-QXiOmnCz=kKgf1mrsHRR_Xy6eido97gmU80SZQ@mail.gmail.com>
 <EAE997AA-1144-49D6-824B-E981F12EEF2B@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EAE997AA-1144-49D6-824B-E981F12EEF2B-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 31, 2017 at 9:25 AM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
>> On May 31, 2017, at 6:16 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>
>> I think there may be more than just changing the MAC. The Mellanox
>> documentation talks about unbinding and re-binding the VF.
> Correct.. I thought you've already done that.
> So basically the flow is as follow:
> 1. Create VFs on the hypervisor
> 2. Configure MAC addresses to the VFs on the Hypervisor
> 3. Unbind the VFs drivers
> 4. Bind back

We aren't using the VFs for VMs, but I don't think that matters. I
think even reading the documentation several times, I was trying to
access the bind/unbind sysfs entries from the wrong part of the tree.
I did an unbind/bind and the MAC address on the rs81p1v0 device and
the GUID was set. All looks good now!

Thanks,

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
