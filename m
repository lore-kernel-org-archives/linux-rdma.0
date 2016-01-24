From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 18:52:46 -0800
Message-ID: <CA+55aFymjONiSk+gVRk8XaViw9BuG1A6KgGWHgq=kj+XZsEw8w@mail.gmail.com>
References: <56A2727B.8040809@redhat.com>
	<CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
	<56A30910.9010002@redhat.com>
	<CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
	<56A3A777.3@redhat.com>
	<CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw@mail.gmail.com>
	<56A3FE6F.4000800@redhat.com>
	<CA+55aFz9Dnu7Ri8XA291VdSYZ5gqyt+cmaaRNULQ0hVetoAJZg@mail.gmail.com>
	<56A42829.90401@redhat.com>
	<CA+55aFy0OuZ+TOsNRkqyGbpJf1LvLAodO2DqUfpcrKsQHQWLxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFy0OuZ+TOsNRkqyGbpJf1LvLAodO2DqUfpcrKsQHQWLxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 23, 2016 at 6:03 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> That "struct mlx5_ifc_cmd_hca_cap_bits" is a major pain in the arse,
> for example.

So here is the end of this from the two branches before the merge:

 - from the networking tree:

        u8         reserved_60[0x1b];
        u8         log_max_wq_sz[0x5];

        u8         nic_vport_change_event[0x1];
        u8         reserved_61[0xa];
        u8         log_max_vlan_list[0x5];
        u8         reserved_62[0x3];
        u8         log_max_current_mc_list[0x5];
        u8         reserved_63[0x3];
        u8         log_max_current_uc_list[0x5];

        u8         reserved_64[0x80];

 - from your tree:

        u8         reserved_60[0x1b];
        u8         log_max_wq_sz[0x5];

        u8         reserved_61[0xa0];

(I've thrown out the common parts at the beginning of that structure).

Now, that's a split that makes sense: the "reserved_61[0xa0]" in the
second case has been split right. Good. It matches, and they both add
up to the same size (0xa0 bytes).

Then we have a common part (except the "reserved_xyz" numbers now
don't match due to the split:

 - networking tree again:

        u8         reserved_65[0x3];
        u8         log_max_l2_table[0x5];
        u8         reserved_66[0x8];
        u8         log_uar_page_sz[0x10];

 - your branch:

        u8         reserved_62[0x3];
        u8         log_max_l2_table[0x5];
        u8         reserved_63[0x8];
        u8         log_uar_page_sz[0x10];


Fine, still matching, just annoying to merge due to the different
names for the reserved areas.

Then, we have another split:

 - networking tree:

        u8         reserved_67[0x40];
        u8         device_frequency_khz[0x20];
        u8         reserved_68[0x5f];
        u8         cqe_zip[0x1];

        u8         cqe_zip_timeout[0x10];
        u8         cqe_zip_max_num[0x10];

        u8         reserved_69[0x220];

 - your branch:

        u8         reserved_64[0x20];
        u8         device_frequency_mhz[0x20];
        u8         device_frequency_khz[0x20];
        u8         reserved_65[0xa0];

        u8         reserved_66[0x1f];
        u8         cqe_zip[0x1];

        u8         cqe_zip_timeout[0x10];
        u8         cqe_zip_max_num[0x10];

        u8         reserved_67[0x220];

Ok, so your branch inserted that 32-byte "device_frequency_mhz" thing,
which is why the reserved area 67/64 changed in size.

But look at what happens *after* that. The networking tree has

        u8         reserved_68[0x5f];

but your branch has

        u8         reserved_65[0xa0];

        u8         reserved_66[0x1f];

before the cqe_zip[]. They no longer match up. Something bad happened
in one of the branches, and "cqe_zip[]" and the subsequent fields are
at different offsets.

This is impossible to merge. One of the branches is wrong.

I picked one at random, not having the energy to figure out where
those offsets went wrong.

But it annoys me enormously how much time and effort I had to put into
this merge.

Because it was all a complete waste of my time. I could have done more
productive, or at least more pleasant things. Like digging out my eyes
with a rusty spoon rather than look at this crap and trying to count
byte offsets.

If those "reserved" fields were named for the expected offset they are
at, then not only wouldn't the names have changed (which would have
made things much easier to merge - the parts that weren't split would
have auto-merged cleanly and correctly), but it would be much more
obvious which one was right and which one was wrong.

As it is, it's impossible to tell without knowing the hardware details
or going back in history and trying to see where the offsets magically
changed.

                Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
