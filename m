From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 16:38:23 -0800
Message-ID: <CA+55aFz9Dnu7Ri8XA291VdSYZ5gqyt+cmaaRNULQ0hVetoAJZg@mail.gmail.com>
References: <56A2727B.8040809@redhat.com>
	<CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
	<56A30910.9010002@redhat.com>
	<CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
	<56A3A777.3@redhat.com>
	<CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw@mail.gmail.com>
	<56A3FE6F.4000800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56A3FE6F.4000800-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 23, 2016 at 2:27 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> So how ready and stable is this? IOW, if I do this pull, can I rely on
>> that being "it", and really just get fixes.
>
> I still want to send the staging changes.

I'm not at all convinced I will pull them.

And I'm now looking at pulling the stuff you sent yesterday, and I'm
close to just saying "screw this". Again.

This is now the *second* time that two different teams inside Mellanox
decided to play games with the kernel maintainers, and I'm not at all
sure the end result is not worth my time to sort out.

Doug, you need to stop taking patches from the Mellanox people until
the get their shit together.  Really. I'll spend some time looking at
this mess, but next time I see two Mellanox groups fighting inside
their own driver, I will just not pull. It's that simple. If you take
shit from them, I'll not take the end result.

I don't know what problem the Mellanox people have, but one group
sends their changes through the networking tree, and another group
sends it through you. They do similar things, but different enough to
not be the same.

You tell them to stop sending that stuff to you, because I'm getting
it through Davem. And I'm not interested in cleaning up after their
mess.

Adding David and Mellanox people to the cc.

This kind of idiocy where one company has two different groups, and
they are fighting over the same driver, and then expecting upstream to
sort out their mental problems for them is not acceptable. It's not
the job of either me or the subsystem maintainers to sort out your
differences for you.

                  Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
