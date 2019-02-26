From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH v1 iproute2-next 3/4] rdma: add 'link add/delete' commands
Date: Tue, 26 Feb 2019 11:24:32 -0600
Message-ID: <94c6a44c-6f08-ffe8-9798-a4faf14bd29a@opengridcomputing.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <5dd9d9aeada48bc5db0eb0394ed4e3ce38ee41bc.1550773362.git.swise@opengridcomputing.com>
 <20190223094311.GP23561@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190223094311.GP23561@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


On 2/23/2019 3:43 AM, Leon Romanovsky wrote:
> On Thu, Feb 21, 2019 at 08:19:12AM -0800, Steve Wise wrote:
>> Add new 'link' subcommand 'add' and 'delete' to allow binding a soft-rdma
>> device to a netdev interface.
>>
>> EG:
>>
>> rdma link add rxe_eth0 type rxe netdev eth0
>> rdma link delete rxe_eth0
>>
>> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
>> ---
>>  rdma/link.c  | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  rdma/rdma.h  |  1 +
>>  rdma/utils.c |  2 +-
>>  3 files changed, 69 insertions(+), 1 deletion(-)
>>
>> diff --git a/rdma/link.c b/rdma/link.c
>> index c064be627be2..afaf19663728 100644
>> --- a/rdma/link.c
>> +++ b/rdma/link.c
>> @@ -14,6 +14,9 @@
>>  static int link_help(struct rd *rd)
>>  {
>>  	pr_out("Usage: %s link show [DEV/PORT_INDEX]\n", rd->filename);
>> +	pr_out("Usage: %s link add NAME type TYPE netdev NETDEV\n",
>> +	       rd->filename);
>> +	pr_out("Usage: %s link delete NAME\n", rd->filename);
>>  	return 0;
>>  }
>>
>> @@ -341,10 +344,74 @@ static int link_show(struct rd *rd)
>>  	return rd_exec_link(rd, link_one_show, true);
>>  }
>>
>> +static int link_add(struct rd *rd)
>> +{
>> +	char *name;
>> +	char *type = NULL;
>> +	char *dev = NULL;
>> +	uint32_t seq;
>> +
>> +	if (rd_no_arg(rd)) {
>> +		pr_err("No link name was supplied\n");
> I think that it is better to have instruction message and not error
> message: "Please provide ...".


Ok.  Perhaps a new utility rd_exec_require_link() can be created?


>> +		return -EINVAL;
>> +	}
>> +	name = rd_argv(rd);
>> +	rd_arg_inc(rd);
>> +	while (!rd_no_arg(rd)) {
>> +		if (rd_argv_match(rd, "type")) {
>> +			rd_arg_inc(rd);
>> +			type = rd_argv(rd);
>> +		} else if (rd_argv_match(rd, "netdev")) {
>> +			rd_arg_inc(rd);
>> +			dev = rd_argv(rd);
>> +		} else {
>> +			pr_err("Invalid parameter %s\n", rd_argv(rd));
>> +			return -EINVAL;
>> +		}
>> +		rd_arg_inc(rd);
> Please use chains of struct rd_cmd and rd_exec_cmd() instead of
> open-coding parser.


Ok.  Like your recently merged series did...


>> +	}
>> +	if (!type) {
>> +		pr_err("No type was supplied\n");
>> +		return -EINVAL;
> General parser handle it.


Ok.


>> +	}
>> +	if (!dev) {
>> +		pr_err("No net device was supplied\n");
>> +		return -EINVAL;
>> +	}
> rd_exec_require_dev() ???


Looks like I can use that.  I'll try it.


Thanks!


Steve.
