From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] read_config: skip file/directory with unsecure
 permissions
Date: Mon, 12 Aug 2013 14:39:35 -0600
Message-ID: <20130812203935.GA8990@obsidianresearch.com>
References: <cover.1369085762.git.ydroneaud@opteya.com>
 <0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud@opteya.com>
 <20130521205713.GB11318@obsidianresearch.com>
 <1375989856.27609.10.camel@localhost.localdomain>
 <20130812190545.GA7968@obsidianresearch.com>
 <8d276f12593ddc79233fa41abdaf0d41@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8d276f12593ddc79233fa41abdaf0d41-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 12, 2013 at 10:24:55PM +0200, Yann Droneaud wrote:

> It's an installation error that can allow an attackant to tamper
> the configuration files. Once the configuration files are modified
> to load a payload, the attackant can either trick root to execute
> a verbs/RDMA program or use a verbs/RDMA setuid program to gain root
> access.

libibverbs does not have to defend itself against installation
errors. If you install stuff wrong, with the wrong permissions, you
will have an insecure system.

You have added checks for a single set of permissions, but there are
many other permissions that must also be correct to be secure for
setuid.

Fundamentally it is not the Unix Way to enforce security policy in
code.

> We don't have to wait for exploit to secure the loading mechanism of
> libibverbs.

What possible exploit? If installed properly the code is already
correct and not exploitable.

You are not fixing *ANYTHING* exploitable here. You are mis-applying
the CWE's you quoted. They fundamentally do not apply when all the
path components have secure permissions.

> >In any event, if these checks really are necessary they should be only
> >done if running in a setuid context, and they almost certainly need to
> >extend to the dlopen paths as well..

> They need to be done when the configuration files are owned by a
> different user that the one using the library (eg. running a program
> tied to the library).

No, that is not the Unix Way.

Only the setuid case ever needs special handling, and that handling
should be designed to prevent the unprivileged user from co-opting the
program while it is running as root.

All other case, including running verbs non-setuid as root, should
respect the normal permission systems.

> I put the emphasis on setuid use case, but a program run as root
> using configuration file owned by another user is more likely to
> happen (for devel, test purpose).

This should work fine as well. It is the sysadmin's choice to install
the config files under alternate permissions.

Funamentally a library should not enforce security policy if it not
necessary to do so.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
