From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Maintain a single connection per I_T nexus
Date: Thu, 13 Jun 2013 16:00:57 +0200
Message-ID: <51B9D099.1040708@profitbricks.com>
References: <1371036597-23483-1-git-send-email-sebastian.riemer@profitbricks.com> <51B860D7.9050709@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B860D7.9050709-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart's version also has the printing of the connection string if the
double login fails.

So forget about this version here.

On 12.06.2013 13:51, Sebastian Riemer wrote:
> Hi all,
> 
> as proposed by Or, let's discuss this on the mailing list.
> 
> This is a fundamental change required for everything related to
> multipathing. It influences automatic reconnect patches which will
> follow. So let's agree on the right solution here first before looking
> at other patches.
> 
> In my opinion the 'add_target' sysfs attribute shouldn't be used for any
> manual reconnect as well. This is why my patch rejects the double login
> attempt instead of reconnecting an existing connection.
> This can help to find scripting issues and things like this. We can't
> expect that all users are using the srp-tools.
> 
> Please compare with Bart's version and let's discuss this here.
> https://github.com/bvanassche/ib_srp-backport/commit/7d8774ff58d489858b1c046b2bf01b4e84e8dd9b
> 
> Cheers,
> Sebastian
> 
> 
> On 12.06.2013 13:29, Sebastian Riemer wrote:
>> The sysfs attribute 'add_target' may not be used for multiple logins to
>> the same target. If doing so with multipathing, this crashes the
>> multipath-tools. Furthermore, we want to prevent the possibility of data
>> corruption here. If manual reconnect is necessary, then the user can use
>> the 'delete' sysfs attribute of the remote port before connecting.
>>
>> Note: The function srp_conn_unique() has been taken from Bart Van Assche.
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
