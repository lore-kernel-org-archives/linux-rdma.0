From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v7 0/9] SELinux support for Infiniband RDMA
Date: Mon, 22 May 2017 15:14:02 -0400
Message-ID: <CAHC9VhQbLmdzQDyeY=j4M=hw-arSmft68ri08Pu1cxpCaFPGpA@mail.gmail.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com> <alpine.LRH.2.20.1705221033550.3502@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.20.1705221033550.3502-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 21, 2017 at 8:35 PM, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 19 May 2017, Dan Jurgens wrote:
>
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> What kind of testing has this code had?  It's relatively complex and as a
> security feature, it especially needs to be well-tested.

Check the relevant threads on the SELinux list as well as Daniel's
response.  Aside from the usual developer unit testing, we've gone
through multiple rounds of reviews and have gotten ACKs from the IB
folks.  Daniel is currently working on adding tests to the
selinux-testsuite (see the SELinux list for the patches) and I merged
this to the selinux/next branch last week so we could get as much
exposure as possible before the next merge window (linux-next has
already caught two things).  I did let Daniel know that inclusion in
the next pull request is contingent on the tests being in place (as
well as the userspace, policy, etc.).

I think we are in a good spot right now with this patchset, especially
considering we are only at -rc2 and still have several weeks before
the next merge window opens.

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
