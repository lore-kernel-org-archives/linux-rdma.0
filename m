From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 1 Apr 2016 05:46:56 +0300
Message-ID: <20160401024656.GG2670@leon.nu>
References: <20160323105708.GP25216@leon.nu>
 <56F29C32.305@redhat.com>
 <20160331233828.GE2670@leon.nu>
 <20160331.221847.53272383417094737.davem@davemloft.net>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160331.221847.53272383417094737.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: dledford@redhat.com, torvalds@linux-foundation.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, matanb@mellanox.com, ogerlitz@mellanox.com, leonro@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 31, 2016 at 10:18:47PM -0400, David Miller wrote:
> From: Leon Romanovsky <leon@leon.nu>
> Date: Fri, 1 Apr 2016 02:38:28 +0300
> 
> > On Wed, Mar 23, 2016 at 09:37:54AM -0400, Doug Ledford wrote:
> >> On 03/23/2016 06:57 AM, Leon Romanovsky wrote:
> >> > On Sat, Mar 19, 2016 at 02:37:08PM -0700, Linus Torvalds wrote:
> >> >> So the *best* situation would be:
> >> >>
> >> >>  - your two groups talk it over, and figure out what the common commits are
> >> >>
> >> >>  - you put those common commits as a "base" branch in git
> >> >>
> >> >>  - you ask the two upper-level maintainers to both pull that base branch
> >> >>
> >> >>  - you then make sure that you send the later patches (whether as
> >> >> emailed patches or as pull requests) based on top of that base branch.
> >> > 
> >> > Hi David and Doug,
> >> > 
> >> > Are you OK with the approach suggested by Linus?
> >> > We are eager to know it, so we will adopt it as soon
> >> > as possible in our development flow.
> >> > 
> >> > The original thread [1].
> >> > 
> >> > [1] http://thread.gmane.org/gmane.linux.drivers.rdma/34907
> >> > 
> >> > Thanks.
> >> > 
> >> 
> >> I'm fine with it.  Since I happen to use topic branches to build my
> >> for-next from anyway, I might need to be the one that Dave pulls from
> >> versus the other way around.
> > 
> > Resending to linux-netdev.
> > 
> > David,
> > Can you please express your opinion about Linus's suggestion to
> > eliminate merge conflicts in Mellanox related products?
> 
> Sure, sounds fine.

Thank you, I appreciate a lot Doug's and your openness and
willingness to help us eliminate the future merge obstacles.
