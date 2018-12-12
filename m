From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Tue, 11 Dec 2018 21:04:41 -0600
Message-ID: <CAErSpo5skJK0vkQp3t+-YJ-Fw_vpo2f9GUsU9DnnhtO6X+v0mw@mail.gmail.com>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181211140143.GD99796@google.com> <20181212002234.GC2719@umbus.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181212002234.GC2719@umbus.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Bjorn Helgaas <helgaas@kernel.org>, David Miller <davem@davemloft.net>, saeedm@mellanox.com, Or Gerlitz <ogerlitz@mellanox.com>, tariqt@mellanox.com, leon@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, netdev <netdev@vger.kernel.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, sbest@redhat.com, paulus@samba.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 11, 2018 at 6:38 PM David Gibson
<david@gibson.dropbear.id.au> wrote:
>
> On Tue, Dec 11, 2018 at 08:01:43AM -0600, Bjorn Helgaas wrote:
> > Hi David,
> >
> > I see you're still working on this, but if you do end up going this
> > direction eventually, would you mind splitting this into two patches:
> > 1) rename the quirk to make it more generic (but not changing any
> > behavior), and 2) add the ConnectX devices to the quirk.  That way
> > the ConnectX change is smaller and more easily
> > understood/reverted/etc.
>
> Sure.  Would it make sense to send (1) as an independent cleanup,
> while I'm still working out exactly what (if anything) we need for
> (2)?

You could, but I don't think there's really much benefit in doing the
first without the second, and I think there is some value in handling
both patches at the same time.
