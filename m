From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: RE: [PATCH v3 3/4] rsockets: distribute completion queue vectors
Date: Tue, 09 Sep 2014 18:02:41 +0530
Message-ID: <324d0cae53cff595c6949fc93884869f@imap.linux.ibm.com>
References: <33dc77c8c6006b5ac067e6c6f485df60@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DCCC85@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DCCC85-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, sithirug-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2014-09-08 21:24, Hefty, Sean wrote:
>> @@ -548,6 +550,37 @@ void rs_configure(void)
>>   		(void) fscanf(f, "%hu", &restart_onintr);
>>   		fclose(f);
>>   	}
>> +
>> +	if ((f = fopen(RS_CONF_DIR "/comp_vector", "r"))) {
>> +		char vbuf[256];
>> +		char *vptr;
>> +		vptr = fgets(vbuf, sizeof(vbuf), f);
>> +		fclose(f);
>> +		if (vptr) {
>> +			char *tok, *save, *tmp, *str, *tok2;
>> +			int lvect, uvect, vect;
>> +
>> +			for (str = vptr; ; str = NULL) {
>> +				tok = strtok_r(str, ",", &save);
>> +				if (tok == NULL) {
>> +					break;
>> +				}
>> +				if (!(tmp = strpbrk(tok, "-"))) {
>> +					lvect = uvect = atoi(tok);
>> +				} else {
>> +					tok2 = tmp + 1;
>> +					*tmp = '\0';
>> +					lvect = atoi(tok);
>> +					uvect = atoi(tok2);
>> +				}
>> +				lvect = (lvect < 0) ? 0 : ((lvect > 63) ? 63 :
>> lvect);
>> +				uvect = (uvect < 0) ? 0 : ((uvect > 63) ? 63 :
>> uvect);
>> +				for (vect = lvect; vect <= uvect; vect++) {
>> +					comp_vector_mask |= ((uint64_t)1 << vect);
>> +				}
>> +			}
>> +		}
>> +	}
> 
> Please isolate this functionality into its own function.
> 
> - Sean

Hi Sean,

I will make this into a separate function in the revised patch that is
being worked out.

Thank You.

- Sreedhar

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" 
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
