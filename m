From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 00/13] SELinux support for Infiniband RDMA
Date: Mon, 11 Apr 2016 20:38:50 +0000
Message-ID: <DB5PR05MB111168B6670B36F12979705BC4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <20160411201155.GC371@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Content-Language: en-US
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/11/2016 3:12 PM, Jason Gunthorpe wrote:
> On Thu, Apr 07, 2016 at 02:33:45AM +0300, Dan Jurgens wrote:
> 
>> Currently there is no way to provide granular access control to an Infiniband
>> fabric.  By providing an ability to restrict user access to specific virtual
>> subfabrics administrators can limit access to bandwidth and isolate users on
>> the fabric.
> 
> Do you actually have a concrete use case for this?

We know the national labs are interested in this.

> This seems superficially similar to netlabel, which I guess targets a
> certain niche, but I'm really wondering with all the other container
> patches if this was supposed to be done with namespaces...

I can't speak to the goals of the other container patches.

Netlabel can't label kernel bypassed packets.  It can be used for IPoIB
though.

>> An Infiniband device (ibdev) is labeled by name and port number.  There is a
>> single access vector for ibdevs as well, called "smi".
> 
> This is called an End Port (SMI is something else in the IB
> spec). Please use the standard terminology.
I see your point on the end port, I'll address this is the next series
by updating the commit messages and replacing ibdev with ibendport.

I don't understand where you think I've gone wrong on SMI.

>From section 3.4.5.2: "Each node provides a Subnet Management Agent
(SMA) that the SM access through a well known interface called the
Subnet Management Interface (SMI)."

Thanks,
Dan


_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
