From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Thu, 11 Jan 2018 16:33:53 -0500
Message-ID: <1515706433.21421.11.camel@redhat.com>
References: <1515531652.26021.1.camel@redhat.com>
         <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
         <20180110182648.GI4518@ziepe.ca> <1515609623.2745.20.camel@wdc.com>
         <1515610750.10153.1.camel@redhat.com> <20180110191510.GK4518@ziepe.ca>
         <1515612639.10153.3.camel@redhat.com> <20180110205243.GP4776@mellanox.com>
         <1515618674.10153.6.camel@redhat.com> <20180110211501.GS4776@mellanox.com>
         <1515675741.21421.1.camel@redhat.com> <1515703435.21421.9.camel@redhat.com>
         <1515705340.2752.60.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515705340.2752.60.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2018-01-11 at 21:15 +0000, Bart Van Assche wrote:
> On Thu, 2018-01-11 at 15:43 -0500, Laurence Oberman wrote:
> > Server log
> > ----------
> > Linux fedstorage.bos.redhat.com 4.15.0-rc7.bart+ #1 SMP Thu Jan 11
> > 14:17:33 EST 2018 x86_64 x86_64 x86_64 GNU/Linux
> > [root@fedstorage ~]# [  533.405291] IPv6: ADDRCONF(NETDEV_CHANGE):
> > ib0: link becomes ready
> > [  533.442884] IPv6: ADDRCONF(NETDEV_CHANGE): ib1: link becomes
> > ready
> > [  540.024438] ib_srpt Received SRP_LOGIN_REQ with i_port_id
> > 7cfe:9003:0072:6e4e:7cfe:9003:0072:6ed2, t_port_id
> > 7cfe:9003:0072:6e4e:7cfe:9003:0072:6e4e and it_iu_len 2116 on port
> > 1
> > (guid=fe80:0000:0000:0000:7cfe:9003:0072:6e4e); pkey 0xffff
> > [  540.141464] ib_srpt failed to create queue pair with sq_size =
> > 16384 (-12) - retrying
> > [  540.186159] ib_srpt failed to create queue pair with sq_size =
> > 8192 (-12) - retrying
> > [  540.231794] ib_srpt Rejected login for initiator
> > 7cfe:9003:0072:6ed2: ret = -13.
> > [  540.274077] ib_srpt Rejecting login with reason 0x10006
> 
> Hello Laurence,
> 
> I think that means that no ACL was configured on the target side for
> initiator port 7cfe:9003:0072:6ed2. Can you provide the output of
> (cd /sys/kernel/config/target/srpt && ls -d */*/acls/*)?
> 
> Thanks,
> 
> Bart.
> NrybXǧv^)޺{.n+{ٚ{ay
ʇڙ,jfhz
w
j:+vwjmzZ+ݢj"!


Hi Bart

I have not changed the configuration in LIO target though.
The /etc/target json file is the same as always and Its been like this
for years

I just rebooted the server into 4.13 and its fine again and found all
the targets with the same kernel on the client.

So its specific to your new tree with srpt

I will reboot again and re-load LIO and show you but here is my ACL
list that has been this way for some time.


o- srpt
.......................................................................
...................................... [Targets: 2]
  | o- ib.fe800000000000007cfe900300726e4e
.......................................................................
.... [no-gen-acls]
  | | o- acls
.......................................................................
..................................... [ACLs: 8]
  | | | o- ib.4e6e72000390fe7c7cfe900300726ed2
...................................................................
[Mapped LUNs: 30]
  | | | o- ib.4e6e72000390fe7c7cfe900300726ed3
...................................................................
[Mapped LUNs: 30]
  | | | o- ib.4f6e72000390fe7c7cfe900300726ed2
...................................................................
[Mapped LUNs: 30]
  | | | o- ib.4f6e72000390fe7c7cfe900300726ed3
...................................................................
[Mapped LUNs: 30]
  | | | o- ib.7cfe900300726e4e7cfe900300726ed2
...................................................................
[Mapped LUNs: 30]
  | | | o- ib.7cfe900300726e4e7cfe900300726ed3
...................................................................
[Mapped LUNs: 30]
  | | | o- ib.7cfe900300726e4f7cfe900300726ed2
...................................................................
[Mapped LUNs: 30]
  | | | o- ib.fe800000000000007cfe900300726e4e
...................................................................
[Mapped LUNs: 30]
  | o- ib.fe800000000000007cfe900300726e4f
.......................................................................
.... [no-gen-acls]
  |   o- acls
.......................................................................
..................................... [ACLs: 8]
  |   | o- ib.4e6e72000390fe7c7cfe900300726ed2
...................................................................
[Mapped LUNs: 30]
  |   | o- ib.4e6e72000390fe7c7cfe900300726ed3
...................................................................
[Mapped LUNs: 30]
  |   | o- ib.4f6e72000390fe7c7cfe900300726ed2
...................................................................
[Mapped LUNs: 30]
  |   | o- ib.4f6e72000390fe7c7cfe900300726ed3
...................................................................
[Mapped LUNs: 30]
  |   | o- ib.7cfe900300726e4e7cfe900300726ed2
...................................................................
[Mapped LUNs: 30]
  |   | o- ib.7cfe900300726e4e7cfe900300726ed3
...................................................................
[Mapped LUNs: 30]
  |   | o- ib.7cfe900300726e4f7cfe900300726ed2
...................................................................
[Mapped LUNs: 30]
  |   | o- ib.7cfe900300726e4f7cfe900300726ed3
...................................................................
[Mapped LUNs: 30]


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
