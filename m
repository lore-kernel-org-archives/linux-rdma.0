From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] Add receive Flow Steering support
Date: Tue, 21 May 2013 23:02:28 +0300
Message-ID: <CAJZOPZKny4MAs5qYWSa9RpQAdcptJw4dHRO26uKRewBAE3zg7A@mail.gmail.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com>
	<20130520225423.GB16639@sbohrermbp13-local.rgmadvisors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130520225423.GB16639-/vebjAlq/uFE7V8Yqttd03bhEEblAqRIDbRjUBewulXQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 21, 2013 at 1:54 AM, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Are there any patches for libibverbs to add
> ibv_create_flow/ibv_destroy_flow?  And are there any needed patches
> for libmlx4?  I'm building up a stack so we can begin testing this series.

YES there are patches NO I didn't post them here yet, as I went the
bottom-up way of 1st posting kernel patches and once they are accepted
(which didn't happen yet) post the user space patches. Last week over
the Linux EU summit, people made comments that the flow-steering
patches looks OK, and I understand Roland is fine with accepting them
for the 3.11 merge window. I do want you or anyone else to start
testing them right away, please start with getting  a system with 3.10
+ the flow-steering patches to run and I will post here in the coming
days pointer to user space implementation you can use for testing the
kernel patches.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
