From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Mon, 25 May 2015 23:58:18 -0600
Message-ID: <20150526055818.GB22461@obsidianresearch.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
 <1432226406.28905.22.camel@redhat.com>
 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
 <1432242708.28905.73.camel@redhat.com>
 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
 <20150525211433.GA9186@obsidianresearch.com>
 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
 <20150525223235.GA9858@obsidianresearch.com>
 <CAJ3xEMjSU0xVWyqd8v_-OO5JvsHycGTU6gg=BHpZD8PSqRfzQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjSU0xVWyqd8v_-OO5JvsHycGTU6gg=BHpZD8PSqRfzQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 26, 2015 at 06:33:15AM +0300, Or Gerlitz wrote:
> > This allows generic code to work with the LLADDR - for instance 'ip
> > link set vf mac' should have checked the size of the IFLA_ADDRESS and
> > demanded that the address argument is the same number of bytes. It is
> > very broken the command happily accepts an 8 byte and 6 byte argument
> > for the same device.
> 
> OK, so per your view, the existing kernel code for this flow is broken
> and you resist my attempt to use it as is, and

What does that mean?

The current kernel code that uses this interface is all ethernet
drivers. They use 6 bytes, in exactly the same format as the
LLADDR. Do you see something different?

And yes, the kernel code for this interface is very much inconsistent
with the rest of netlink. Carrying a LLADDR in a fixed and unsized 32
byte array and calling it a 'mac' is awful.

Looking through the comments from 2010 on the patch that introduced
this function, it is pretty clear that the original author did not
understand netlink.

The userspace side in iproute2 is even worse:

static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
{
...
        fprintf(fp, "\n    vf %d MAC %s", vf_mac->vf,
	                ll_addr_n2a((unsigned char *)&vf_mac->mac,
			                ETH_ALEN, 0, b1, sizeof(b1)));

Hard coded ETH_ALEN! For a 32 byte array! BLECK!

And the set side:

static int iplink_parse_vf(int vf, int *argcp, char ***argvp,
                           struct iplink_req *req, int dev_index)
{
...
      len = ll_addr_a2n((char *)ivm.mac, 32, *argv);
      if (len < 0)
          return -1;
      addattr_l(&req->n, sizeof(*req), IFLA_VF_MAC, &ivm, sizeof(ivm));

It just passes random stack garbage into the kernel if the
user doesn't provide 32 bytes on the command line. BLECK!

The kernel didn't even validate the *length* of address sub attribute
until recently:

https://patchwork.ozlabs.org/patch/436901/

So, to your question yes, I think it is broken / horribly written.

But we can live with it, we don't need to radically change it.

So. looking at this interface there are two options for the 32
byte fixed array:
 1) 'mac' is some arbitary interface specific thing with no relation
    to anything else in netlink
 2) 'mac' is a LLADDR, and must match the construction of IFLA_ADDRESS

Speaking generally - netlink is a general purpose interface - #2 is by
far the saner of the two choices.

Why? Because 'ip' needs to know the length of the address for the two
places noted above. Using the same length as IFLA_ADDRESS is simple
and 100% general.

Using a lookup on the device type to guess the address length is 8
because it is infiniband, but 6 for ethernet, and who knows what if
the tool is old and doesn't recognize the device type.. Crappy. Not
The Netlink Way.

Thus, the very best choice (at this point) is to use the length of the
IFLA_ADDRESS (aka dev->addr_len), which is completely general and
works for every single device choice.

Is #1 possible? Yes. But linux-rdma is the wrong place to make that
choice. Ask netdev.

[ .. if we could go back in time fixing the original patch to use a
  *sized* array for IFLA_VF_MAC would have been ideal, and made #1
  much more desirable, but that is not straightforward now, and we
  have to live with the bad choices someone else made. Try not to
  add to this crap .. ]
  
> > Yes, it is ugly that the PF side's ndo_get_vf_config cannot return the
> > same 20 byte address of the VF's ipoib interface, but I think that is
> > less ugly than forcing a different address format just for the vf calls.
> 
> you claim that what I propose is uglier from the fact that the PF can't
> by no means return the 20 VF's IPoIB address and it's OK if I only let
> the PF configure 20 bytes with part (say four) of them being arbitrary
> and only have consistent 20B get/set by the PF.
> 
> Would you be happier if the ipoib ndo_set_vf_mac ndo be
> 
> 1. getting 20B from user-space and treating 16 of them as the VF
> subnet-prefix (8B) + vGUID (8B)
> 
> 2. checking that the subnet-prefix  is correct
> 
> 3. provision the vGUID through PF driver / the verb I proposed for the VF
> 
> ???
> 
> on the way back, for the get_vf_config
> 
> 1. read the VF vGUID from the PF IB driver through the verbs
> 
> 2. add the port subnet prefix
> 
> 3. return 20B to user-space
> 
> ???

Yes, absolutely. That maintains the general invariant for LLADDR and
the broad integrity of the existing netlink design.

Using anything else is also short sited. Current hardware is
restricted to a randomized QPN, and current IBA is restricted to a
single GID prefix: But are you *absolutely* sure that will be the case
forever? This is a UAPI, after all.

I'm not: For instance controlling/choosing the QPN solves real issues
with live migration of VF IPoIB - the need to invalidate remote ND
entires when the QPN changes on migration.

> I am not @ the point to change start changing this specific netlink flow.

We are not changing anything, we are trying to guess what netdev wants
to use the fixed 32 byte array called 'mac' for, when we are not going
to store a MAC in it. This is new territory, never been done before.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
