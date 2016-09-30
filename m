From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Fri, 30 Sep 2016 15:59:55 -0400
Message-ID: <CAHC9VhTBW9VsMHag41x1GWUbwPQeLngi8_iq9CPuQ=UMxDebkg@mail.gmail.com>
References: <20160830184633.GE7586@obsidianresearch.com> <VI1PR0501MB2429992B1165DFADC6A6C35AC4E00@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <20160830185548.GA9768@obsidianresearch.com> <VI1PR0501MB242974DEE5E0BF2FFE3A5DA0C4E00@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <20160901163418.GA6479@obsidianresearch.com> <CAHC9VhR-u-ZXMeLkZL7y3=DJP5XaH7CxcZ=b5z67wVwhaPcUhQ@mail.gmail.com>
 <20160906200221.GE28416@obsidianresearch.com> <CAHC9VhRXDMiK5V0rOQTvtZB0Q8jTX7XecGmAfRhm8oqF9aBaiw@mail.gmail.com>
 <VI1PR0501MB24299E036F1FCD335A2C2049C4C80@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <CAHC9VhShCgxonV1rN-J7LyezamzZtKNZ1SR7ywnTB9Kgia_u1w@mail.gmail.com> <20160929224146.GE27229@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160929224146.GE27229@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Daniel Jurgens <danielj@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 6:41 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Thu, Sep 29, 2016 at 06:16:03PM -0400, Paul Moore wrote:
>> The queue pair (QP) concept lives in the RDMA layer and isn't tied to
>> any particular transport.  They appear to be somewhat analogous to
>> network sockets, although I'm guessing they can't be shared/passed
>> between process like a network socket, yes?
>
> Yes

Okay, that should make life easier.

>> The IB partition is similar to a ethernet VLAN in that it providedes
>> enforced separation across the network; IB uses partition keys, VLANs
>> use tags/IDs.  IB partition keys are a 16 bit number,
>
>> GIDs appear to be a 16 byte number created from some combination of
>> IP address, MAC address, and VLAN ID.
>
> There are several gid formats
>
> IB/OPA: 128 bit IPv6 address
> RoCEv1: Sort of a link local IPv6 (?), vlan is specified directly
>         by apps
> RoCEv2: Some sort of label that also implies a vlan tag

Thanks for the extra information, but at this point I don't think the
exact format is important; I'm just trying to get a basic
understanding of what we might need to do.

> We also have iwarp vs rocee where AFAIK iwarp should get the vlan tag
> from the IP socket that is allocated against the eth interface.

Sigh.

So we've got RDMA over IB (does this have an acronym?  my googling
isn't showing anything ...), RoCEv1 which appears to be RDMA over
Ethernet (although it looks like it might still use an IP header?),
RoCEv2 which appears to be RDMA over UDP, and iWARP which seems to be
RDMA over TCP/SCTP.  Are there any others?

We've already talked about the RDMA/IB's pkeys and RoCEv1's GID/VLANs,
but RoCEv2 and iWARP are a little more interesting as they ride on top
of a routable network transport.  Do RoCEv2 and iWARP use the kernel's
stack, or is that off-loaded?  Actually, now that I think of it,
RoCEv2 and iWARP are probably implemented as userspace libraries
aren't they?  The kernel probably doesn't know or care about these
protocols at all, or does it?

>> In the case of RDMA over IB, we want to control QP access to
>> partitions/pkeys; in the case of RDMA over ethernet we want to control
>> QP access to VLANs/GIDs.
>
> Broadly, yes, and I don't know what restriction iwarp would
> need. Probably restrict access based on the eth device, but that will
> probably need additional selinux checking in the rdma core.
>
> There are also UD QPs which are like UDP sockets, so every address
> handle creation will need a security check too.

-- 
paul moore
www.paul-moore.com
