From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sun, 24 Jan 2016 18:19:18 +0200
Message-ID: <56A4F986.5070604@mellanox.com>
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
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFy0OuZ+TOsNRkqyGbpJf1LvLAodO2DqUfpcrKsQHQWLxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/24/2016 4:03 AM, Linus Torvalds wrote:
> On Sat, Jan 23, 2016 at 5:26 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On 01/23/2016 07:38 PM, Linus Torvalds wrote:
>>> This kind of idiocy where one company has two different groups, and
>>> they are fighting over the same driver, and then expecting upstream to
>>> sort out their mental problems for them is not acceptable. It's not
>>> the job of either me or the subsystem maintainers to sort out your
>>> differences for you.
>> Can I get some specifics of what you are talking about here?  The reason
>> I ask is that I know in this merge cycle there was a function modified
>> in the mlx4 driver (I think, or maybe mlx5) where it was first modified
>> by a patch series that went through Dave's tree, then further modified
>> by a series in my tree.
> So these are in your tree:
>
>    mlx5_core: Break down the vport mac address query function
>    net/mlx5_core: Introduce access functions to enable/disable RoCE
>    net/mlx5_core: Introduce access functions to query vport RoCE fields
>
> and the networking tree has
>
>    net/mlx5: Update access functions to Query/Modify vport MAC address
>    net/mlx5: Introduce access functions to modify/query vport mac lists
>    net/mlx5: Introduce access functions to modify/query vport state
>    net/mlx5: Introduce access functions to modify/query vport promisc mode
>    net/mlx5: Introduce access functions to modify/query vport vlans
>
> which are _similar_ but different. The differences are small annoying
> details, like slightly different error handling ("goto out" vs just
> conditional), slightly different arguments (vport or not), and a mix
> of EXPORT_SYMBOL and EXPORT_SYMBOL_GPL.
>
> The differences are just *stupid*. They are doing very similar things
> in very similar areas, but the two groups didn't try to match things
> up or apparently talk to each other, or try to actively make it easier
> for maintainers to merge their annoying small differences to the exact
> same area of the file.
>
> So they just changed their driver as if they were the only people
> working on it. Two separate groups. In the same company.
> What is even more annoying to merge, though, is how the two groups
> again separately changed the structures that apparently describe the
> hardware layout of things.
>
> That "struct mlx5_ifc_cmd_hca_cap_bits" is a major pain in the arse,
> for example. It doesn't help that the *undocumented* parts of that
> array are described with things like
>
>      u8 reserved_66[0x8];
>     ...
>      u8 reserved_67[0x40];
>
> and then when one group documents something in the middle of that
> reserved region, it gets split up and the reserved_NNN[xyz] numbers
> change.

Linus,

Re different styling (branching, exporting), in the same driver, point 
taken.
We will work to improve on that through tighter internal codes reviews 
and briefing of people on such practices.

Re the header file that described the layout for the driver / firmware 
layouts, point taken too. We should be changing how the currently 
reserved fields are named, such that when one person opens feature X and 
a 2nd person opens feature Y, both on structure Z, the two people would 
have to change only distinct fields, and hence less noise which creates 
unneeded conflicts.

The Mellanox NIC HW is used for both plain Eth networking and RDMA. The 
upstream RDMA stack support IB, RoCE (RDMA over Eth) and user-space Eth 
offloading.As such, forboth mlx4 and mlx5 there's a core driver plus on 
top of Eth and RDMA driver.

It's possible that for a given merge cycle, we have networking changes that
require core changes and RDMA changes which require different core changes.

We aim to minimize that, but this happens (and is also too sensitive now,
as you pointed out re the mlx5_ifc header, which we need to fix), and... we
counted on linux-next merge tests, as the process to know things are on 
the righttrack.

So I'd like to clarify with you a point re linux-next.

 From my experience working under few maintainers (Dave, Roland, Doug) 
over the years...what the maintainer has to do is (A) register their 
for-next tree/branch to linux-next merge tests and (B) respond to the 
linux-next maintainer when he identifies conflicts and resolves them.

AFAIK, when the conflict is resolved, Stephen uses git rerere to produce 
corrective action and the result is applied from the rr-cache when you 
do the merge.

Can you confirm this is how things work?

A2nd question here, AFAIK, git rerere assumes some ordering... is it 
okay we'll assume that you will always pull the networking changes and 
only later the rdma changes?

The case you mentioned of conflict during one of the 2015 merge windows was
I think with a patch that either landed too late in the rdma-next 
branch, or that the branch wasn't registered for linux-next tests.

For this merge window there were 1-2 cases where Stephen reported and 
solved the conflict,and another one were we did that and sent him the 
rere files. We thought we're all Okay.

As Doug noted, the majority of the code for the merge window was in his 
tree since Dec 24. It's possible that some code landed there later or 
even really close to the point where the pull request sent to you, so 
one conflict went
unnoticed, this we (RDMA maintainer + Mellanox) need to make sure will 
not happen.

And this brings me to the last point, merge tests should be done before 
sending you pull requests. I know Dave is doing that... we will be 
discussing this with Doug to agree on the details.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
