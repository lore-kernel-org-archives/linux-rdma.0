From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Prepared RDMA Tree for 4.7
Date: Wed, 18 May 2016 13:18:09 +0000
Message-ID: <DB5PR05MB11115AAC16B6A3AD0C8E0564C4490@DB5PR05MB1111.eurprd05.prod.outlook.com>
References: <20160512174406.GB11827@leon.nu>
 <9dbc023f-e442-843a-ab68-eec38ca1d6b7@redhat.com>
 <20160513042217.GD11827@leon.nu>
 <9e5233c8-6641-7f6b-3825-1b67eb70c05b@redhat.com>
 <20160514043353.GG11827@leon.nu>
 <f9210e1d-667d-5f62-f1bd-7545a0ff6153@redhat.com>
 <20160515060005.GH11827@leon.nu>
 <04c7b983-66b4-0609-9cf4-3c7b1e126a53@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/16/2016 3:15 PM, Doug Ledford wrote:
> On 05/15/2016 02:00 AM, Leon Romanovsky wrote:
>> On Sat, May 14, 2016 at 09:09:54AM -0400, Doug Ledford wrote:
>>> On 05/14/2016 12:33 AM, Leon Romanovsky wrote:
>>>> On Fri, May 13, 2016 at 12:31:55PM -0400, Doug Ledford wrote:


>>
>> What is wrong with SELinux patches?
> 
> They need time for people to think about them.  You call them the
> SELinux patches, but that is somewhat misleading.  When I think of
> SELinux, I think of things like limited context server applications
> ("Can httpd read home directories?", "Can dovecot write to home
> direcories?  Can dovecot listen on port 993? 995?", etc.)  It's very

The patches are intended to allow exactly that.  Extend the SELinux
policy language to support controlling access to Infiniband partitions.

> general purpose and has a lot of policy that goes with it.  From what I
> read, these patches are different.  They are mainly used to enforce the
> subnet manager's P_Key policy.  There isn't anything else they do.  From

They don't have anything to do with the subnet managers PKey policy.
They enforce SELinux policy to restrict access to partitions.

> that standpoint, they look like the user space half of the namespace
> equation.  But they're devoid of any of the other policy decisions that
> SELinux often makes.  I haven't read them closes enough to see if they
> could be easily extended to implement any of these other types of policy
> or not, but that's certainly an issue.  If you are going to go monkeying
> around in the SELinux subsystem (and 7 of the 12 patches do), then
> making sure we do things in a manner that is not going to paint us into
> a corner seems appropriate.  I haven't had the time to do that level of
> looking at these patches.

Changes to the SELinux subsystem are required to support the changes to
the policy language to label Infiniband pkeys and devices and to provide
an access control query interface.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
