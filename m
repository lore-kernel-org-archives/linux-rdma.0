From: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] SELinux support for Infiniband RDMA
Date: Tue, 5 Apr 2016 11:55:10 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1604051154500.16241@namei.org>
References: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
 <alpine.LRH.2.20.1604051110390.9906@namei.org>
 <DB5PR05MB111126C8AB59CDA4674A068BC49E0@DB5PR05MB1111.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
In-Reply-To: <DB5PR05MB111126C8AB59CDA4674A068BC49E0-8IvNv+8VlcBJTpKhoUy7I9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 5 Apr 2016, Daniel Jurgens wrote:

> On 4/4/2016 8:13 PM, James Morris wrote:
> > On Tue, 5 Apr 2016, Dan Jurgens wrote:
> > 
> >> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>
> >> Currently there is no way to provide granular access control to an Infiniband
> >> fabric.  By providing an ability to restrict user access to specific virtual
> >> subfabrics administrators can limit access to bandwidth and isolate users on
> >> the fabric.
> > 
> > Where are the LSM hooks placed?
> > 
> > 
> > 
> The LSM hooks are defined in patch 1/7 of this series.  There are 4 that
> will be called from ib_core, and one that's implemented by ib_core to be
> called by a security module if the policy or enforcement setting change
> (infiniband_flush).  That call from SELinux is added in patch 3/7 of
> this series.

Can you post the ib_core patches, too?


-- 
James Morris
<jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>

_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
