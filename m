From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v1 02/12] Target/sbc: Set protection operation and
 relevant checks
Date: Tue, 18 Feb 2014 11:53:01 -0800
Message-ID: <1392753181.28946.18.camel@haakon3.risingtidesystems.com>
References: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
	 <1392572297-5333-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392572297-5333-3-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Sun, 2014-02-16 at 19:38 +0200, Sagi Grimberg wrote:
> SBC-3 mandates the protection checks that must be
> performed in the rdprotect/wrprotect field. Use them.
> According to backstore device pi_attributes and
> cdb rdprotect/wrprotect.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/target/target_core_sbc.c  |   88 ++++++++++++++++++++++++++++++++++---
>  include/target/target_core_base.h |    7 +++
>  2 files changed, 88 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index a448944..dfeb1c2 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -240,6 +240,11 @@ static inline u32 transport_lba_32(unsigned char *cdb)
>  	return (cdb[2] << 24) | (cdb[3] << 16) | (cdb[4] << 8) | cdb[5];
>  }
>  
> +static inline u8 rwprotect(unsigned char *cdb)
> +{
> +	return cdb[1] >> 5;
> +}
> +

No need for this one-liner.  Go ahead and inline instead..

>  static inline unsigned long long transport_lba_64(unsigned char *cdb)
>  {
>  	unsigned int __v1, __v2;
> @@ -569,30 +574,95 @@ sbc_compare_and_write(struct se_cmd *cmd)
>  	return TCM_NO_SENSE;
>  }
>  
> +static int
> +sbc_set_prot_op_checks(u8 protect, enum target_prot_type prot_type,
> +		       u8 op, struct se_cmd *cmd)
> +{
> +	switch (op) {
> +	case READ_10:
> +	case READ_12:
> +	case READ_16:
> +		cmd->prot_op = protect ? TARGET_PROT_DIN_PASS :
> +					 TARGET_PROT_DIN_STRIP;
> +		switch (protect) {
> +		case 0x0:
> +		case 0x1:
> +		case 0x5:
> +			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
> +			if (prot_type == TARGET_DIF_TYPE1_PROT)
> +				cmd->prot_checks |= TARGET_DIF_CHECK_REFTAG;
> +			break;
> +		case 0x2:
> +			if (prot_type == TARGET_DIF_TYPE1_PROT)
> +				cmd->prot_checks = TARGET_DIF_CHECK_REFTAG;
> +			break;
> +		case 0x3:
> +			cmd->prot_checks = 0;
> +			break;
> +		case 0x4:
> +			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
> +			break;
> +		default:
> +			pr_err("Unsupported protect field %d\n", protect);
> +			return -EINVAL;
> +		}
> +		break;
> +	case WRITE_10:
> +	case WRITE_12:
> +	case WRITE_16:
> +	case WRITE_VERIFY:
> +		cmd->prot_op = protect ? TARGET_PROT_DOUT_PASS :
> +					 TARGET_PROT_DOUT_INSERT;
> +		switch (protect) {
> +		case 0x0:
> +		case 0x3:
> +			cmd->prot_checks = 0;
> +		case 0x1:
> +		case 0x5:
> +			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
> +			if (prot_type == TARGET_DIF_TYPE1_PROT)
> +				cmd->prot_checks |= TARGET_DIF_CHECK_REFTAG;
> +			break;
> +		case 0x2:
> +			if (prot_type == TARGET_DIF_TYPE1_PROT)
> +				cmd->prot_checks = TARGET_DIF_CHECK_REFTAG;
> +			break;
> +		case 0x4:
> +			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
> +			break;
> +		default:
> +			pr_err("Unsupported protect field %d\n", protect);
> +			return -EINVAL;
> +		}
> +		break;
> +	default:
> +		pr_err("ERROR: bad opcode %d\n", op);
> +		return TCM_INVALID_CDB_FIELD;
> +	}
> +
> +	return 0;
> +}
> +

sbc_set_prot_op_checks() is probably better served by passing in a bool
to determine read/write, than performing a switch on individual CDB
opcode.

--nab
