From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH 00/12] SELinux support for Infiniband RDMA
Date: Wed, 29 Jun 2016 13:33:44 -0400
Message-ID: <CAHC9VhRKFmZ+thwqbq8JnGbj04+Uex4JM0CS=umjfUQB90k0VQ@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dan Jurgens <danielj@mellanox.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: chrisw@sous-sol.org, Eric Paris <eparis@parisplace.org>, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj@mellanox.com> wrote:
> From: Daniel Jurgens <danielj@mellanox.com>
>
> This patch series was submitted previously as an RFC.  The 3rd version was
> posted on 19 Apr 2016 with the subject "[RFC PATCH v3 NN/MM] SELinux support
> for Infiniband RDMA".

Hi Dan,

Thanks for sticking with this patchset, I'm working through it right
now and I have a question on the overall design (below).

> Because RDMA allows for kernel bypass all enforcement must be done during
> connection setup.  To communicate over RDMA requires a send and receive queue
> called a queue pair (QP).  During the creation of a QP it is initialized
> before it can be used to send or receive data.  During initialization the user
> must provide the PKey and port the QP will use, at this time access can be
> enforced.
>
> Because there is a possibility that the enforcement settings or security
> policy can change, a means of notifying the ib_core module of such changes is
> required.  To facilitate this two LSM hooks are provided, ib_core will
> register and unregister a callback function at init and cleanup respectively.
> SELinux will call the callback as appropriate if it has been registered.
> When the callback is called ib_core will recheck the PKey access for all
> existing QPs.

...

> In order to properly enforce security when changes to the PKey table or
> security policy or enforcement occur ib_core must track which QPs are using
> each port, pkey index, and alternate path for every IB device.  This makes
> operations that used to be atomic transactional.
>
> When modifying a QP ib_core must associate it with the PKey index, port,
> and alternate path specified.  If the QP was already associated with different
> settings the QP is added to the new list prior to the modify attempt.  If
> the modify succeeds then the old listing is removed.  If the modify fails
> the new listing is removed and the old listing remains unchanged.
>
> When destroying a QP the ib_qp structure is freed by the hardware driver
> if the destroy is successful.  This requires storing security related
> information in a separate structure. When a destroy request is in process
> the ib_qp structure is in an undefined state so if there are changes to the
> security policy or PKey table the security checks cannot reset the QP if it
> doesn't have permission for the new setting.  If the destroy fails security
> for that QP must be enforced again, and its status in the list restored.
> If the destroy succeeds the security info can be cleaned up and freed.

Perhaps I'll end up answering this for myself as I work my way through
the patches, but hopefully you are handling the case where a destroy
operation fails and the QP needs to be revalidated?

I'm also wondering if QP revalidation on a security policy change is
worth the trouble; we've historically not been able to provide any
revoke guarantees so I'm not sure if it is worth a lot of added
complexity to gain this functionality just for Infiniband.  That said,
it would be *nice* to have revalidation/revocation working, even if
only for IB.  It may be that we need similar code to handle the
various corner cases, so we may be stuck with the complexity anyway, I
just thought it was worth bringing up as a topic of discussion.

-- 
paul moore
www.paul-moore.com
