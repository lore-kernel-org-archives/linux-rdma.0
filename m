From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6 3/9] selinux lsm IB/core: Implement LSM notification
 system
Date: Tue, 13 Dec 2016 14:38:54 +0000
Message-ID: <DB6PR0501MB24224ED80DC88FB3BC44BF9FC49B0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
 <1479910651-43246-4-git-send-email-danielj@mellanox.com>
 <8165ef76-d620-5904-e38e-90d258a30683@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Content-Language: en-US
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/13/2016 8:26 AM, Stephen Smalley wrote:
> On 11/23/2016 09:17 AM, Dan Jurgens wrote:
>> @@ -177,6 +177,8 @@ static ssize_t sel_write_enforce(struct file *file, const char __user *buf,
>>  			avc_ss_reset(0);
>>  		selnl_notify_setenforce(selinux_enforcing);
>>  		selinux_status_update_setenforce(selinux_enforcing);
>> +		if (!selinux_enforcing)
>> +			call_lsm_notifier(LSM_POLICY_CHANGE, NULL);
> Why do you need this notification?  When switching from permissive to
> enforcing, you need (and already get) a notification since you may need
> to revoke previously granted permissions.  But what action do you need
> to take on switching to permissive?
MAD (management datagram) Agents cache if they are allowed to send and receive subnet management protocol (SMP) datagrams.  Without this notification they will still drop all SMPs in permissive mode if they weren't allowed in enforcing mode.  This is handled in [PATCH v6 4/9] IB/core: Enforce security on management datagrams.


_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
