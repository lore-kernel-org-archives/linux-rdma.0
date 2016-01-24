From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 18:03:27 -0800
Message-ID: <CA+55aFy0OuZ+TOsNRkqyGbpJf1LvLAodO2DqUfpcrKsQHQWLxw@mail.gmail.com>
References: <56A2727B.8040809@redhat.com>
	<CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
	<56A30910.9010002@redhat.com>
	<CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
	<56A3A777.3@redhat.com>
	<CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw@mail.gmail.com>
	<56A3FE6F.4000800@redhat.com>
	<CA+55aFz9Dnu7Ri8XA291VdSYZ5gqyt+cmaaRNULQ0hVetoAJZg@mail.gmail.com>
	<56A42829.90401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56A42829.90401-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 23, 2016 at 5:26 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 01/23/2016 07:38 PM, Linus Torvalds wrote:
>>
>> This kind of idiocy where one company has two different groups, and
>> they are fighting over the same driver, and then expecting upstream to
>> sort out their mental problems for them is not acceptable. It's not
>> the job of either me or the subsystem maintainers to sort out your
>> differences for you.
>
> Can I get some specifics of what you are talking about here?  The reason
> I ask is that I know in this merge cycle there was a function modified
> in the mlx4 driver (I think, or maybe mlx5) where it was first modified
> by a patch series that went through Dave's tree, then further modified
> by a series in my tree.

So these are in your tree:

  mlx5_core: Break down the vport mac address query function
  net/mlx5_core: Introduce access functions to enable/disable RoCE
  net/mlx5_core: Introduce access functions to query vport RoCE fields

and the networking tree has

  net/mlx5: Update access functions to Query/Modify vport MAC address
  net/mlx5: Introduce access functions to modify/query vport mac lists
  net/mlx5: Introduce access functions to modify/query vport state
  net/mlx5: Introduce access functions to modify/query vport promisc mode
  net/mlx5: Introduce access functions to modify/query vport vlans

which are _similar_ but different. The differences are small annoying
details, like slightly different error handling ("goto out" vs just
conditional), slightly different arguments (vport or not), and a mix
of EXPORT_SYMBOL and EXPORT_SYMBOL_GPL.

The differences are just *stupid*. They are doing very similar things
in very similar areas, but the two groups didn't try to match things
up or apparently talk to each other, or try to actively make it easier
for maintainers to merge their annoying small differences to the exact
same area of the file.

So they just changed their driver as if they were the only people
working on it. Two separate groups. In the same company.

What is even more annoying to merge, though, is how the two groups
again separately changed the structures that apparently describe the
hardware layout of things.

That "struct mlx5_ifc_cmd_hca_cap_bits" is a major pain in the arse,
for example. It doesn't help that the *undocumented* parts of that
array are described with things like

    u8 reserved_66[0x8];
   ...
    u8 reserved_67[0x40];

and then when one group documents something in the middle of that
reserved region, it gets split up and the reserved_NNN[xyz] numbers
change.

In fact, just looking at that particular "struct
mlx5_ifc_cmd_hca_cap_bits", I think one of the two branches got the
padding wrong at some point, because they no longer seem to agree
about the offsets in the structure.

Imagine what a joy it is to merge crap like that.

If it was two different independent groups, I'd go "ok, this is my
life now", take an extra dose of happy pills, and merge things.
Because I'd be the person who has to sort that shit out. It's my job.

But what annoys me about this situation is that the two groups that
crap on each other are in the same company. They should talk to each
other.

For example, to make those hardware descriptor structures easier to
keep track of (not just for merging, since apparently people got the
offsets wrong even outside of the merges), maybe instead of using a
random number for the reserved field, the code could use the expected
_offset_. So instead of

    u8 reserved_66[0x8];

it could be something like

    u8 reserved_at_0240[0x8];

to not cause the stupid things to change names just because some
_earlier_ reserved field was split. Add a few lines of
offsets-in-comments in the parts that don't have a lot of
"reserved_xyz[]" fields, and suddenly those hardware description
structures would be a hell of a lot easier to see what they do.

Because right now they literally have random noise in them. This is a
random sampling:

   ...
    u8 reserved_60[0x1b];
    u8 reserved_61[0xa];
    u8 reserved_62[0x3];
    u8 reserved_63[0x3];
    u8 reserved_64[0x80];
    u8 reserved_65[0x3];
    u8 reserved_66[0x8];
    u8 reserved_67[0x20];
    u8 reserved_68[0x5f];
    u8 reserved_69[0x220];
    u8 reserved_0[0x20];
    u8 reserved_0[0xa00];
   ...

and that's a _small_ random sampling: there are about 1500 lines of
those kinds of "reserved_nn[]" fields in that one file.

Just imagine how fun it is to see one of those random numbers (one of
the bigger ones), split - completely differently - in the two
different versions, and everything else get renumbered.

I wish I was kidding. I'm not.

[ I'm actually planning on re-doing my merge with something like that
in both branches before the merge, just because I want to make sure I
got the offsets right - maybe the reason I think somebody screwed up
their offsets earlier was just because I screwed up when trying to
merge this mess ]

But even more than things like that, I'd expect that two groups inside
of Mellanox would talk to each other, and NOT MERGE DIFFERENT CHANGES
TO THE SAME DRIVER THROUGH TWO DIFFERENT MAINTAINERS!

Or maybe they could use a shared git branch to at least handle the
common changes so that they don't conflict. Or maybe they should split
up their driver so that the two different groups don't step on each
others toes. Or maybe the could use tricks like that
"reserved_at_offset[]" thing to at least make the step-on-each-other
not be such a pain.

In other words, there are lots of different alternatives to improve on
what's going on. But this "throw crap against the wall and hope it
sticks" approach that the two groups are clearly using now is *not*
acceptable.

If this was the first time it happened, I'd just be annoyed. As it is,
something similar happened not that long ago, witht he same people. At
this point I'm past "pissed", and firmly in "if this happens again,
I'll just stop pulling the crap" camp.

                  Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
