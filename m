From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 05/12] selinux: Implement Infiniband PKey "Access" access
 vector
Date: Mon, 11 Jul 2016 19:03:26 +0000
Message-ID: <DB6PR0501MB2261B291887EF0431AD5701BC43F0@DB6PR0501MB2261.eurprd05.prod.outlook.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-6-git-send-email-danielj@mellanox.com>
 <1c637b46-7352-b369-4891-4b695ff80b3b@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://prometheus.infosec.tycho.ncsc.mil/mailman/options/selinux>,
 <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://prometheus.infosec.tycho.ncsc.mil/pipermail/selinux/>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
List-Subscribe: <http://prometheus.infosec.tycho.ncsc.mil/mailman/listinfo/selinux>,
 <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=subscribe>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/11/2016 9:45 AM, Stephen Smalley wrote:
> On 06/23/2016 03:52 PM, Dan Jurgens wrote:
>> diff --git a/security/selinux/include/initial_sid_to_string.h b/security/selinux/include/initial_sid_to_string.h
>> index a59b64e..8f2eefc 100644
>> --- a/security/selinux/include/initial_sid_to_string.h
>> +++ b/security/selinux/include/initial_sid_to_string.h
>> @@ -29,5 +29,6 @@ static const char *initial_sid_to_string[] =
>>      "policy",
>>      "scmp_packet",
>>      "devnull",
>> +    "pkey",
> I don't think we can/should add any more initial SIDs until we have
> dynamic discovery support for them.  At present, we'll have problems
> with old kernel with new policy and with new kernel with old policy when
> the number of initial SIDs changes.
>
>> +	if (c) {
>> +		if (!c->sid[0]) {
>> +			rc = sidtab_context_to_sid(&sidtab,
>> +						   &c->context[0],
>> +						   &c->sid[0]);
>> +			if (rc)
>> +				goto out;
>> +		}
>> +		*out_sid = c->sid[0];
>> +	} else {
>> +		*out_sid = SECINITSID_PKEY;
> Could we just use SECINITSID_UNLABELED as the default?
>
I don't see why that would be a problem.  I'll take the same comment for the "[PATCH 06/12] selinux: Add IB End Port SMP access vector".


_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
