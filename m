From: "Sean Hefty" <sean.hefty@intel.com>
Subject: RE: Re: [PATCH] osm_subnet.c
Date: Mon, 5 Oct 2009 09:20:40 -0700
Message-ID: <A6E929B3F38F455EB28EB478FBAF290E@amr.corp.intel.com>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8A8F@orsmsx501.amr.corp.intel.com>
	<20091004001316.GK17846@me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <20091004001316.GK17846@me>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: 'Sasha Khapyorsky' <sashak@voltaire.com>, "Smith, Stan" <stan.smith@intel.com>
Cc: ofw@lists.openfabrics.org, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>>  /**********************************************************************
>>   **********************************************************************/
>> -static long compar_mgids(const void *m1, const void *m2)
>> +static intn_t compar_mgids(const void *m1, const void *m2)
>
>Any disagreement about changing a prototype of this method
>(cl_pfn_fmap_cmp_t) in complib to use standard type (long) instead of
>"homemade" and less clear one ('intn_t')?
>
>Sasha
>
>>  {
>>         return memcmp(m1, m2, sizeof(ib_gid_t));
>>  }

If the function is simply a wrapper around a single call to memcmp, why keep it
at all?
