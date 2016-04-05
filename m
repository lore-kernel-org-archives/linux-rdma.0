From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] SELinux support for Infiniband RDMA
Date: Tue, 5 Apr 2016 01:31:26 +0000
Message-ID: <DB5PR05MB111126C8AB59CDA4674A068BC49E0@DB5PR05MB1111.eurprd05.prod.outlook.com>
References: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
 <alpine.LRH.2.20.1604051110390.9906@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Content-Language: en-US
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/4/2016 8:13 PM, James Morris wrote:
> On Tue, 5 Apr 2016, Dan Jurgens wrote:
> 
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Currently there is no way to provide granular access control to an Infiniband
>> fabric.  By providing an ability to restrict user access to specific virtual
>> subfabrics administrators can limit access to bandwidth and isolate users on
>> the fabric.
> 
> Where are the LSM hooks placed?
> 
> 
> 
The LSM hooks are defined in patch 1/7 of this series.  There are 4 that
will be called from ib_core, and one that's implemented by ib_core to be
called by a security module if the policy or enforcement setting change
(infiniband_flush).  That call from SELinux is added in patch 3/7 of
this series.

_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
